require 'rubygems'
require 'sinatra'
require 'tilt/erb'
require 'httparty'
require 'json'
require 'rest-client'
require 'base64'
require 'date'
require 'action_view'
include ActionView::Helpers::DateHelper

require './config/init.rb'
require './config/products.rb'

set :root, File.dirname(__FILE__)

helpers do
	def build_salesgraph(datasequences, minTotal, maxTotal, type)
		salesGraph = {
		    :graph =>  {
		        :title => settings.graphTitle,
		        :total => settings.displayTotal,
		        :refresh => settings.refreshInterval,
		        :type => type,
		        :yAxis => {
		            :hide => settings.hideTotals,
		            # :units => { :prefix => "Total " },
		            :minValue => minTotal,
		            :maxValue => maxTotal,
		            :scaleTo => settings.scaleTo
		        },
		        :datasequences => datasequences
		    }
		}
	end

	def comma_numbers(number, delimiter = ',')
	  number.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse
	end

end

get '/' do
	"Welcome to RescueBoard. Set your URL to an endoint, like '/pulse'"
end

get '/pulse' do
	raise Exception.new("Please specify RESCUEBOARD_API_KEY in your environment") if settings.rescueboard_api_key.nil?
	json = RestClient.get("https://www.rescuetime.com/anapi/daily_summary_feed?key=#{settings.rescueboard_api_key}")
	jhash = JSON.parse(json)
	pulse = jhash[0]["productivity_pulse"]
	hours = jhash[0]["total_duration_formatted"]
	erb :latest, locals: {:pulse => pulse, :hours => hours}
end

get '/appstore/downloads' do
	raise Exception.new("Please specify AF_USERNAME in your environment") if settings.af_username.nil?
	raise Exception.new("Please specify AF_PASSWORD in your environment") if settings.af_password.nil?
	raise Exception.new("Please specify AF_CLIENT_KEY in your environment") if settings.af_client_key.nil?

	type = params[:type] || "line"
	days = params[:days] || 7

	months = { "1" => "Jan", "2" => "Feb", "3" => "Mar", "4" => "Apr", "5" => "May", "6" => "Jun", "7" => "Jul", "8" => "Aug", "9" => "Sep", "10" => "Oct", "11" => "Nov", "12" => "Dec" }
	startDate = (Date.today - days.to_i).strftime("%Y-%m-%d")
	endDate = (Date.today - 1).strftime("%Y-%m-%d")
	datasequences = []
	minTotal = 0
	maxTotal = 1
	lastDate = []

	settings.products.each do |p|
	    salesData = []
	    response = HTTParty.get("https://api.appfigures.com/v2/sales/products+dates/?start_date=#{startDate}&end_date=#{endDate}&granularity=daily&products=#{p[:id]}", :headers => { "X-Client-Key" => settings.af_client_key}, :basic_auth => {:username => settings.af_username, :password => settings.af_password })
	    response.parsed_response.sort.each do |day|
	        day_hash = day[1]
	        day_hash.each do |data|
	            newDate = Date.parse(data[1]['date'])
	            dateString = "#{newDate.day} #{months["#{newDate.month}"]}"
	            downloads = comma_numbers(data[1]["downloads"].to_i)
	            maxTotal = downloads.to_i if downloads.to_i > maxTotal
	            minTotal = downloads.to_i if downloads.to_i < minTotal || minTotal == 1
	            salesData << { :title => dateString, :value => downloads }
	            lastDate = dateString
	        end
	    end
	    datasequences << { :title => p[:title], :color => p[:color], :datapoints => salesData }
	end
	build_salesgraph(datasequences,minTotal, maxTotal, type).to_json
end

get '/appstore/sales/:app_id' do |n|
	raise Exception.new("Please specify AF_USERNAME in your environment") if settings.af_username.nil?
	raise Exception.new("Please specify AF_PASSWORD in your environment") if settings.af_password.nil?
	raise Exception.new("Please specify AF_CLIENT_KEY in your environment") if settings.af_client_key.nil?

	months = { "1" => "Jan", "2" => "Feb", "3" => "Mar", "4" => "Apr", "5" => "May", "6" => "Jun", "7" => "Jul", "8" => "Aug", "9" => "Sep", "10" => "Oct", "11" => "Nov", "12" => "Dec" }
	startDate = (Date.today - days.to_i).strftime("%Y-%m-%d")
	endDate = (Date.today - 1).strftime("%Y-%m-%d")
	datasequences = []
	
	salesData = []
	response = HTTParty.get("https://api.appfigures.com/v2/reports/sales/?group_by=product&start_date=${startDate}&end_date=${endDate}&granularity=year&products=#{n}&dataset=none&include_inapps=true&format=json", :headers => { "X-Client-Key" => settings.af_client_key}, :basic_auth => {:username => settings.af_username, :password => settings.af_password })
	response.parsed_response.sort.each do |day|
	    day_hash = day[1]
	    day_hash.each do |data|
	        newDate = Date.parse(data[1]['date'])
            dateString = "#{newDate.day} #{months["#{newDate.month}"]}"
            downloads = comma_numbers(data[1]["downloads"].to_i)
            maxTotal = downloads.to_i if downloads.to_i > maxTotal
            minTotal = downloads.to_i if downloads.to_i < minTotal || minTotal == 1
            salesData << { :title => dateString, :value => downloads }
            lastDate = dateString
        end
    end
    datasequences << { :title => p[:title], :color => p[:color], :datapoints => salesData }
end