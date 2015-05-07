require 'rubygems'
require 'sinatra'
require 'tilt/erb'
require 'httparty'
require 'json'
require 'rest-client'

configure do
	set :root, File.dirname(__FILE__)
	set :title, "RescueBoard for Statusboard"
	set :rescueboard_api_key, ENV['RESCUEBOARD_API_KEY']
	set :af_username, ENV['AF_USERNAME']
	set :af_password, ENV['AF_PASSWORD']
	set :af_client_key, ENV['AF_CLIENT_KEY']
end


get '/' do
	"Welcome to RescueBoard. Set your URL to an endoint, like '/today'"
end

get '/latest' do
	raise Exception.new("Please specify RESCUEBOARD_API_KEY in your environment") if settings.rescueboard_api_key.nil?
	json = RestClient.get("https://www.rescuetime.com/anapi/daily_summary_feed?key=#{settings.rescueboard_api_key}")
	jhash = JSON.parse(json)
	pulse = jhash[0]["productivity_pulse"]
	hours = jhash[0]["total_duration_formatted"]
	erb :index, locals: {:pulse => pulse, :hours => hours}
end

get '/sales' do
	raise Exception.new("Please specify AF_USERNAME in your environment") if settings.af_username.nil?
	raise Exception.new("Please specify AF_PASSWORD in your environment") if settings.af_password.nil?
	raise Exception.new("Please specify AF_CLIENT_KEY in your environment") if settings.af_client_key.nil?
	# string to allow bar or line
	# call salesboard.rb
	# salesGraph
end
