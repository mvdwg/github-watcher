require 'sequel'
Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost/github_watcher')

class Alert < Sequel::Model
  # last_sha
  # owner
  # repo
  # branch
  # path
  # user_id
  one_to_many :alarms
end

class Alarm < Sequel::Model
  # alert_id
  # first_sha
  # second_sha
  # status
end

class User < Sequel::Model
  # github_id
  # github_login
  one_to_many :alerts
end
