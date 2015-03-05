# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

env :PATH, ENV['PATH']

set :output, {standard: 'log/cron_standard.log', error: 'log/cron_error.log'}
set :environment, :production

every 15.minutes do
  rake "account:follow_all"
  rake "account:unfollow_all"
end

every 13.minutes do
  rake "account:send_direct_messages_all"
end

every 47.minutes do
  rake "account:retweet_all"
end

every 1.hours do
  rake "account:update_all_statuses"
end