# == Schema Information
#
# Table name: accounts
#
#  id                  :integer          not null, primary key
#  group_id            :integer          not null
#  screen_name         :string(255)      not null
#  oauth_token         :string(255)      not null
#  oauth_token_secret  :string(255)      not null
#  friends_count       :integer          default("0")
#  followers_count     :integer          default("0")
#  description         :string(255)      default("")
#  auto_update         :boolean          default("1")
#  auto_follow         :boolean          default("1")
#  auto_unfollow       :boolean          default("1")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  auto_direct_message :boolean          default("1")
#  target_id           :integer
#

class Account < ActiveRecord::Base

  belongs_to :group
  has_many :follower_histories
  has_many :sent_messages
  belongs_to :target
  has_many :followed_users

  delegate :name, :screen_name, to: :target, prefix: true, allow_nil: true

  # 全てのアカウントのデータを更新する
  #
  # @return [nil]
  def self.update_all_statuses

    accounts     = Account.where(auto_update: true).select(:id, :screen_name)
    screen_names = accounts.pluck(:screen_name)
    users        = Account.last.get_users(screen_names)

    followerHistories = []
    Account.transaction do
      accounts.where(screen_name: users.map(&:screen_name)).each do |account|
        user = users.find &-> u { u.screen_name == account.screen_name }
        account.update(
          friends_count:   user.friends_count,
          followers_count: user.followers_count
          )
        followerHistories << FollowerHistory.new(
          account_id: account.id,
          followers_count: user.followers_count
          )
      end
    end
    FollowerHistory.import followerHistories

  end

  # 全てのアカウントについてフォロー操作を行う
  #
  # @return [nil]
  def self.follow_all
    Account.where(auto_follow: true).where.not(target_id: nil).includes({target: :followed_users}).each do |a|
      a.follow_users
    end
  end

  # 全てのアカウントについてフォロー解除操作を行う
  #
  # @return [nil]
  def self.unfollow_all
    Account.where(auto_unfollow: true).includes(:followed_users).each do |a|
      a.unfollow_users
    end
  end

  # 全てのアカウントについてDMの送信作業を行う
  #
  # @return [nil]
  def self.send_direct_messages_all
    Account.joins(:group).where.not(group:[message_pattern_id: nil]).where(auto_direct_message: true).each do |a|
      a.send_direct_messages
    end
  end

  # 複数のユーザーの取得
  #
  # @param [Array<String>] targets ターゲットアカウントのscreen_name
  # @return [Array<Twitter::User>] users Twitterユーザーリスト情報.
  def get_users(targets)
    begin
      users = client.users(targets)
    rescue => e
      error_log(e)
    end
    users
  end

  # ユーザーのフォロー
  #
  # @param [Fixnum] n フォローを試みる回数
  # @return [nil]
  def follow_users(n=15)

    target_follower_ids = get_follower_ids(self.target.screen_name)
    return unless target_follower_ids

    account_friend_ids = get_friend_ids
    return unless account_friend_ids

    followed_users = self.target.followed_users.pluck(:user_id)

    oneside_ids = target_follower_ids - account_friend_ids - followed_users

    followed = []
    oneside_ids.each_with_index do |target, i|
      break if i+1 > n
      if user = follow_user(target)
        followed << FollowedUser.new(
          account_id: self.id,
          target_id:  self.target.id,
          user_id:user[0].id) if user.length > 0
      end
    end
    FollowedUser.import followed if followed.length > 0

    self.update target_id: nil if oneside_ids.length == 0

  end

  # ユーザーのフォロー解除
  #
  # @param [Fixnum] n フォロー解除する数
  # @return [nil]
  def unfollow_users(n=15)

    friend_ids = get_friend_ids
    return unless friend_ids

    follower_ids = get_follower_ids
    return unless follower_ids

    # 古い順に解除していく
    oneside_ids = (friend_ids - follower_ids).reverse

    # 2日以内にフォローした人を除く
    followed_users = self.followed_users.where(FollowedUser.arel_table[:created_at].gt(2.days.ago)).pluck(:user_id)
    oneside_ids = oneside_ids - followed_users

    unfollowed = []
    oneside_ids.each_with_index do |target, i|
      break if i+1 > n
      if user = unfollow_user(target)
        unfollowed << user[0].screen_name if user.length > 0
      end
    end

    info_log unfollowed
  end

  # DMの送信
  #
  # @param [Fixnum] n 一度にDMを送信する数
  # @return [nil]
  def send_direct_messages(n=5)

    follower_ids = get_follower_ids
    return unless follower_ids

    direct_messages = self.group.message_pattern.direct_messages.order(:step)

    sent_num = 0

    # 返信
    if recieved_messages = get_direct_messages
      recieved_messages.each do |mes|
        # 返事が来ていれば、次のステップのメッセージを送信する
        if sent_message = self.sent_messages.find_by(to_user_id: mes.to_h[:sender_id])
          if sent_message.created_at < mes.to_h[:created_at].to_datetime
            message = direct_messages.where(DirectMessage.arel_table[:step].gt(sent_message.direct_message.step)).first
            if message && send_direct_message(sent_message.to_user_id, message.text)
              sent_message.update(direct_message_id: message.id)
              sent_num += 1
              return if sent_num+1 > n
            end
          end
        end
      end
    end

    # 新規送信
    follower_ids.each do |follower_id|
      unless self.sent_messages.find_by(to_user_id: follower_id)
        message = direct_messages.first
        if send_direct_message(follower_id, message.text)
          sent_messages.create(to_user_id: follower_id, direct_message_id: message.id)
          sent_num += 1
          return if sent_num+1 > n
        end
      end
    end
  end

  # private

  #################
  #
  #    API操作
  #
  #################

  # クライアントの取得
  #
  # @return [Twitter::REST::Client] client Twitterクライアント
  def client
    @client ||=
    Twitter::REST::Client.new(
      consumer_key:       Rails.application.secrets.twitter_consumer_key,
      consumer_secret:    Rails.application.secrets.twitter_consumer_secret,
      access_token:        self.oauth_token,
      access_token_secret: self.oauth_token_secret
      )
  end

  # ユーザーの取得
  #
  # @param [String] target ターゲットアカウントのscreen_name
  # @return [Twitter::User] user Twitterユーザー情報.
  def get_user(target=screen_name)
    begin
      user = client.user(target)
    rescue => e
      error_log(e)
    end
    user
  end

  # ユーザーのフォロー
  #
  # @param [Fixnum] target ターゲットアカウントのUserID
  # @return [Twitter:User] user フォローしたユーザー
  def follow_user(target)
    begin
      user = client.follow(target)
    rescue => e
      error_log(e)
      return nil
    end
    user
  end

  # ユーザーのフォロー解除
  #
  # @param [Fixnum] target ターゲットアカウントのUserID
  # @return [Twitter:User] user フォロー解除したユーザー
  def unfollow_user(target)
    begin
      user = client.unfollow(target)
    rescue => e
      error_log(e)
      return nil
    end
    user
  end

  # ユーザーのタイムラインの取得
  #
  # @param [String] target ターゲットアカウントのscreen_name
  # @return [Array<Twitter::Tweet>] user_timeline ユーザーのタイムライン
  def get_user_timeline(target=screen_name)
    begin
      user_timeline = client.user_timeline(target)
    rescue => e
      error_log(e)
    end
    user_timeline
  end

  # フレンド(フォロー)ID一覧の取得
  #
  # @param [String] target ターゲットアカウントのscreen_name
  # @return [Array<Fixnum>] friend_ids フレンドIDの配列
  def get_friend_ids(target=screen_name)
    begin
      friend_ids = client.friend_ids(target).to_a
    rescue => e
      error_log(e)
    end
    friend_ids
  end

  # フォロワーID一覧の取得
  #
  # @param [String] target ターゲットアカウントのscreen_name
  # @return [Array<Fixnum>] follower_ids フォロワーIDの配列
  def get_follower_ids(target=screen_name)
    begin
      follower_ids = client.follower_ids(target).to_a
    rescue => e
      error_log(e)
    end
    follower_ids
  end

  # DMの取得
  #
  # @param [Fixnum] n 取得する数
  # @return [Array<Twitter::DirectMessage>] messages DM
  def get_direct_messages(n=10)
    begin
      messages = client.direct_messages(count: n)
    rescue => e
      error_log(e)
    end
    messages
  end

  # DMの送信
  #
  # @param [Fixnum] target ターゲットアカウントのID
  # @param [String] text 送る内容
  # @return [Twitter::DirectMessage] message 送ったDM
  def send_direct_message(target, text)
    begin
      message = client.create_direct_message(target, text)
    rescue => e
      error_log(e)
    end
    message
  end

  #################
  #
  #    ログ出力
  #
  #################

  # ログの出力
  #
  # @param [String] contents ログ内容
  # @return [nil]
  def info_log(contents)
    now = DateTime.now.strftime("%m/%d %H:%M")
    method = caller[0][/`([^']*)'/, 1]
    puts "[Info] #{now} #{screen_name}_#{method} #{contents}"
  end

  # エラーログの出力
  #
  # @param [String] contents エラー内容
  # @return [nil]
  def error_log(contents)
    now = DateTime.now.strftime("%m/%d %H:%M")
    method = caller[0][/`([^']*)'/, 1]
    $stderr.puts "[Error] #{now} #{screen_name}_#{method} #{contents}"
  end
end
