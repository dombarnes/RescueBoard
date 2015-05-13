require 'sinatra'

configure do
  set :title, "RescueBoard for Statusboard"
  set :rescueboard_api_key, ENV['RESCUEBOARD_API_KEY']
  set :af_username, ENV['AF_USERNAME']
  set :af_password, ENV['AF_PASSWORD']
  set :af_client_key, ENV['AF_CLIENT_KEY']

  set :salesDays, 10 # Number of days you want to see.
  set :currency, "GBP" # The selected currency under your AppFigures account settings
  set :graphTitle, "" # The title for the graph
  set :graphType, "bar" # This can be 'bar' or 'line'
  set :displayTotal, true # Set to true if you want a total revenue listed at the end of the graph.
  set :hideTotals, false # If you want to see the sales total for each day on the y-axis set this to true
  set :refreshInterval, 120 # Set as seconds. Min 5, default 120
  set :scaleTo, 1 # Set scale size i.e. 1000 to show 8 as 8000
end

configure :production do
end

configure :development do
end
