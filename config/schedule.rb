# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/cron_log.log"
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

every 3.hours do
  runner "Qu.expire_questions(Qu::EXPIRE_6HR)"
end

every 12.hours do
  runner "Qu.expire_questions(Qu::EXPIRE_DAY)"
end

every 3.days do
  runner "Qu.expire_questions(Qu::EXPIRE_WEEK)"
end

every 10.days do
  runner "Qu.expire_questions(Qu::EXPIRE_MONTH)"
end
