require 'dotenv/load'

require "sinatra"

require "./models"
require "./client"

require "omniauth-github"


use Rack::Session::Cookie, secret: ENV["SECRET"]
use OmniAuth::Strategies::GitHub, ENV["CLIENT_ID"], ENV["CLIENT_SECRET"]

get '/' do
  if authenticated?
    @alerts = Alert.all
    @alarms = Alarm.all
    @users = User.all

    erb :index
  else
    erb :login
  end
end

post '/alerts' do
  if authenticated?
    alert = Alert.create(
      user_id: @current_user.id,
      owner: params["owner"],
      repo: params["repo"],
      branch: params["branch"],
      path: params["path"],
    )

    sha = Client.head_sha(alert.owner, alert.repo, alert.branch)

    alert.update(last_sha: sha)

    status 200
  end
end

# Provided by omniauth gem
# get '/auth/github'

get '/auth/github/callback' do
  auth_hash = request.env['omniauth.auth']

  github_id = auth_hash['uid']
  github_login =  auth_hash['info']['nickname']

  user = User.find_or_create(github_id: github_id)
  user.update(github_login: github_login)

  session[:user_id] = user.id

  redirect "/"
end

def authenticate
  @current_user ||= User.find(id: session[:user_id])
end

def authenticated?
  authenticate
end
