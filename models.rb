require 'sequel'
Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost/github_watcher')

class Alert < Sequel::Model
  # last_sha
  # owner
  # repo
  # branch
  # path
end

class Alarm < Sequel::Model
  # alert_id
  # first_sha
  # second_sha
  # status
end
