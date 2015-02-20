# == Schema Information
#
# Table name: accounts
#
#  id                 :integer          not null, primary key
#  screen_name        :string(255)      not null
#  target_user        :string(255)      default("")
#  oauth_token        :string(255)      not null
#  oauth_token_secret :string(255)      not null
#  friends_count      :integer          default("0")
#  followers_count    :integer          default("0")
#  description        :string(255)      default("")
#  usage              :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Account < ActiveRecord::Base

  # 全てのアカウントのデータを更新する
  #
  # @return [nil]
  def self.update_all_statuses

    accounts     = Account.where(auto_update: true).select(:screen_name)
    screen_names = accounts.pluck(:screen_name)
    users        = get_users(screen_names)

    followers_sum = 0
    accounts.where(screen_name: users.map(&:screen_name)).each do |a|
      user = users.find &-> u { u.screen_name == a.screen_name }
      a.update(
        friends_count:   user.friends_count, 
        followers_count: user.followers_count
      )
      followers_sum += user.followers_count
    end

    PowerHistory.create(followers_sum: followers_sum)

  end

  # 全てのアカウントについてフォロー操作を行う
  #
  # @return [nil]
  def self.follow_all
    Account.where(auto_follow: true).where.not(target_user: "").each do |a|
      a.follow_users
    end
  end

  # 全てのアカウントについてフォロー解除操作を行う
  #
  # @return [nil]
  def self.unfollow_all
    Account.where(auto_unfollow: true).each do |a|
      a.unfollow_users
    end
  end

  private

  # ユーザーのフォロー
  #
  # @param [Fixnum] n フォローする数
  # @return [nil]
  def follow_users(n=15)

    target_follower_ids = get_follower_ids(self.target_user)
    return unless target_follower_ids

    account_friend_ids = get_friend_ids
    return unless account_friend_ids

    oneside_ids = target_follower_ids - account_friend_ids

    followed = []
    oneside_ids.each do |target|
      if user = follow_user(target)
        followed << user.screen_name
      end
    end

    self.update target_user: "" if oneside_ids.length == 0
    info_log followed
  end

  # ユーザーのフォロー解除
  #
  # @param [Fixnum] n フォロー解除する数
  # @return [nil]
  def follow_users(n=15)

    friend_ids = get_friend_ids
    return unless friend_ids

    follower_ids = get_follower_ids
    return unless follower_ids

    # 古い順に解除していく
    oneside_ids = (friend_ids - follower_ids).reverse

    unfollowed = []
    oneside_ids.each do |target|
      if user = unfollow_user(target)
        unfollowed << user.screen_name
      end
    end

    info_log unfollowed
  end

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
        oauth_token:        self.oauth_token,
        oauth_token_secret: self.oauth_token_secret
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
