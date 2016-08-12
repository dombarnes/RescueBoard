require 'rubygems'
require 'sinatra'
require 'sinatra/contrib'
require 'tilt/erb'
require 'httparty'
require 'json'
require 'rest-client'
require 'base64'
require 'date'
require 'action_view'
require 'logger'
include ActionView::Helpers::DateHelper

require './config/init.rb'
require './config/products.rb'
$log = Logger.new('logs/output.log','weekly')
set :root, File.dirname(__FILE__)

helpers do
	def build_salesgraph(datasequences, minTotal, maxTotal, chart_type)
		salesGraph = {
		    :graph =>  {
		        :title => settings.graphTitle,
		        :total => settings.displayTotal,
		        :refresh => settings.refreshInterval,
		        :type => chart_type,
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

	def months
		months = { "1" => "Jan", "2" => "Feb", "3" => "Mar", "4" => "Apr", "5" => "May", "6" => "Jun", "7" => "Jul", "8" => "Aug", "9" => "Sep", "10" => "Oct", "11" => "Nov", "12" => "Dec" }
	end

	def build_response(report_type, days, chart_type)
		$datasequences = []
		$salesData = []
		$minTotal = 0
		$maxTotal = 1
		
		startDate = (Date.today - days.to_i).strftime("%Y-%m-%d")
		endDate = (Date.today - 1).strftime("%Y-%m-%d")
		$log.debug "Grabbing data from #{startDate} until #{endDate}"
		settings.products.each do |p|
			response = HTTParty.get("#{settings.endpoint}/reports/sales/?group_by=date&start_date=#{startDate}&end_date=#{endDate}&granularity=daily&products=#{p[:id]}&include_inapps=true&forat=json", :headers => settings.endpoint_headers)
			if response.code == 200
				response.parsed_response.sort.each do |day|
					day_hash = day[1]
					$log.debug "#{p[:title]} #{Date.parse(day_hash['date'])}: #{day_hash["revenue"]}"
					newDate = Date.parse(day_hash['date'])
			        xAxis = "#{newDate.day} #{months["#{newDate.month}"]}"
					report_data = comma_numbers(day_hash["#{report_type}"])
					$maxTotal = report_data.to_i if report_data.to_i > $maxTotal
			        $minTotal = report_data.to_i if report_data.to_i < $minTotal || $minTotal == 1
			        $salesData << { :title => xAxis, :value => report_data }
				end
			else
				$log.debug response.parsed_response
				raise Exception.new("Bad response.\n#{response.message}")
			end
			$datasequences << { :title => p[:title], :color => p[:color], :datapoints => $salesData }
			$salesData = []
		end
		build_salesgraph($datasequences, $minTotal, $maxTotal.round(2), chart_type)
	end

end

before /.*/ do
  if request.url.match(/.json$/)
    request.accept.unshift('application/json')
    request.path_info = request.path_info.gsub(/.json$/,'')
  end
end

get '/' do
	erb :home
end

get '/rescuetime/pulse' do
	raise Exception.new("Please specify RESCUEBOARD_API_KEY in your environment") if settings.rescueboard_api_key.nil?
	
	json = RestClient.get("https://www.rescuetime.com/anapi/daily_summary_feed?key=#{settings.rescueboard_api_key}")
	jhash = JSON.parse(json)
	pulse = jhash[0]["productivity_pulse"]
	hours = jhash[0]["total_duration_formatted"]
	date = Date.parse(jhash[0]["date"])
	fDate = "#{date.day} #{months["#{date.month}"]}"
	erb :pulse, locals: {:pulse => pulse, :hours => hours, :date => fDate}
end # /rescuetime/pulse

get '/appstore/downloads', :provides => [:json] do
	raise Exception.new("Please specify AF_USERNAME in your environment") if settings.af_username.nil?
	raise Exception.new("Please specify AF_PASSWORD in your environment") if settings.af_password.nil?
	raise Exception.new("Please specify AF_CLIENT_KEY in your environment") if settings.af_client_key.nil?

	report_type = "downloads"
	days = params[:days] || 7
	chart_type = params[:type] || "line"

	test_response = HTTParty.get("#{settings.endpoint}", :headers => settings.endpoint_headers )
	case test_response.code
	when 400...600
		$log.debug "Stats #{test_response.code} ERROR: #{test_response.message}"
		$log.debug "Headers: #{test_response.headers.inspect}"
	when 200
		$log.debug "Status 200 OK: API responding"
		@downloads = build_response(report_type, days, chart_type)
    respond_to do |format|
      format.json { @downloads.to_json }
    end
	end
end # /appstore/downloads

get '/appstore/sales', :provides => [:html, :json ] do
	raise Exception.new("Please specify AF_USERNAME in your environment") if settings.af_username.nil?
	raise Exception.new("Please specify AF_PASSWORD in your environment") if settings.af_password.nil?
	raise Exception.new("Please specify AF_CLIENT_KEY in your environment") if settings.af_client_key.nil?

	report_type = "revenue"
	days = params[:days] || 7
	chart_type = params[:type] || "line"

	test_response = HTTParty.get("#{settings.endpoint}", :headers => settings.endpoint_headers )
	case test_response.code
	when 400...600
		$log.debug "Stats #{test_response.code} ERROR: #{test_response.message}"
		$log.debug "Headers: #{test_response.headers.inspect}"
	when 200
		$log.debug "Status 200 OK: API responding"
		@sales = build_response(report_type, days, chart_type)
    # http://www.mayerdan.com/ruby/2013/10/07/sinatra-respond_to-supporting-extensions/
    respond_to do |format|
      format.json { @sales.to_json }
      # format.html { erb :index }
    end
	end

end # /appstore/sales

get '/appstore/revenue/:app_id' do |n|
	raise Exception.new("Please specify AF_USERNAME in your environment") if settings.af_username.nil?
	raise Exception.new("Please specify AF_PASSWORD in your environment") if settings.af_password.nil?
	raise Exception.new("Please specify AF_CLIENT_KEY in your environment") if settings.af_client_key.nil?

	"Coming Soon"
end # /appstore/revenue
