require "sinatra"
require "./models"

get '/' do
  @alerts = Alert.all
  @alarms = Alarm.all

  erb :index
end
