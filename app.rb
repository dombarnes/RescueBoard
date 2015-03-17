
require 'rubygems'
require 'sinatra'
require 'tilt/erb'
require 'httparty'
require 'json'
require 'rest-client'

configure do
	set :root, File.dirname(__FILE__)
	set :rescueboard_api_key, ENV['RESCUEBOARD_API_KEY']
	set :title, "RescueBoard for Statusboard"
end

raise Exception.new("Please specify RESCUEBOARD_API_KEY in your environment") if settings.rescueboard_api_key.nil?

get '/' do
	json = RestClient.get("https://www.rescuetime.com/anapi/daily_summary_feed?key=#{settings.rescueboard_api_key}")
	jhash = JSON.parse(json)
	pulse = jhash[0]["productivity_pulse"]
	hours = jhash[0]["total_duration_formatted"]
	erb :index, locals: {:pulse => pulse, :hours => hours}
end
