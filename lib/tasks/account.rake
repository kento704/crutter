namespace :account do
  # descの記述は必須
  desc "Account"

  task update_all_statuses: :environment do
    result = Benchmark.realtime do
      Account.update_all_statuses
    end
    puts "update_all_statuses: #{result}s"
  end

  task follow_all: :environment do
    result = Benchmark.realtime do
      Account.follow_all
    end
    puts "follow_all: #{result}s"
  end

  task unfollow_all: :environment do
    result = Benchmark.realtime do
     Account.unfollow_all
    end
    puts "unfollow_all: #{result}s"
  end

  task send_direct_messages_all: :environment do
    result = Benchmark.realtime do
      Account.send_direct_messages_all
    end
    puts "send_direct_messages_all: #{result}s"
  end

  task retweet_all: :environment do
    result = Benchmark.realtime do
      # 朝8時以降、20%の確率でリツイート
      Account.retweet_all if DateTime.now.hour >= 8 && rand(100) < 20
    end
    puts "retweet_all: #{result}s"
  end

end