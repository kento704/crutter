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

end