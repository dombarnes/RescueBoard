require 'rubygems'
require 'sinatra'
require 'logger'

Dir.mkdir('logs') unless File.exist?('logs')
$log = Logger.new('logs/output.log','weekly')

configure do
  set :title, "RescueBoard for Statusboard"

  set :rescueboard_api_key, ENV['RESCUEBOARD_API_KEY']
  set :af_username, ENV['AF_USERNAME']
  set :af_password, ENV['AF_PASSWORD']
  set :af_client_key, ENV['AF_CLIENT_KEY']

  set :endpoint, "https://api.appfigures.com/v2"
  set :endpoint_headers, { "X-Client-Key" => settings.af_client_key,
                           "Authorization" => "Basic #{Base64.encode64("#{settings.af_username}:#{settings.af_password}")}"}

  set :graphTitle, "App Store"
  set :currency, "GBP"
  set :displayTotal, true # Set to true if you want a total revenue listed at the end of the graph.
  set :hideTotals, false # If you want to see the sales total for each day on the y-axis set this to true
  set :refreshInterval, 120 # Set as seconds. Min 5, default 120
  set :scaleTo, 1 # Set scale size i.e. 1000 to show 8 as 8000
end

configure :production do
    $log.level = Logger::WARN
end

configure :development do
    $log.level = Logger::DEBUG
end
