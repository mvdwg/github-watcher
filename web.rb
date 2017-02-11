require "sinatra"

require "./models"
require "./client"

get '/' do
  @alerts = Alert.all
  @alarms = Alarm.all

  erb :index
end

post '/alerts' do
  alert = Alert.create(
    owner: params["owner"],
    repo: params["repo"],
    branch: params["branch"],
    path: params["path"],
  )

  sha = Client.head_sha(alert.owner, alert.repo, alert.branch)

  alert.update(last_sha: sha)

  status 200
end
