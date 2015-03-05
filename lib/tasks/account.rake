namespace :account do
  # descの記述は必須
  desc "Account"

  task update_all_statuses: :environment do
    Account.update_all_statuses
  end

  task follow_all: :environment do
    Account.follow_all
  end

  task unfollow_all: :environment do
    Account.unfollow_all
  end

  task send_direct_messages_all: :environment do
    Account.send_direct_messages_all
  end

  task retweet_all: :environment do
    # 朝8時以降、20%の確率でリツイート
    Account.retweet_all if DateTime.now.hour >= 8 && rand(100) < 20
  end

end