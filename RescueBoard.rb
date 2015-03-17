#!/usr/bin/env ruby

# RescueTime Productivity Widget for Statusboard
startTime = Time.now
require 'rubygems'
require 'httparty'
require 'base64'
require 'date'
require 'json'
require 'action_view'
require 'sinatra'
# require 'terminal-notifier'
include ActionView::Helpers::DateHelper

# SalesBoard - An AppFigures script for Status Board
# Created by Justin Williams
# http://twitter.com/justin
# http://carpeaqua.com
#
# If you find this script useful, please consider purchasing one of my two products to show your support:
#
# * Elements for iOS : http://bit.ly/elements20
# * Committed for OS X : http://bit.ly/committed10
#
# The README has more instructions on how to use this thing.

########################################
# Configuration
########################################

apiKey = "B63GP9AzVAG6fRMPQOBfW9HkqJT8BMwtBwALl7lc"  # Your AppFigures username
graphTitle = "" # The title for the graph
graphType = "bar" # This can be 'bar' or 'line'
displayTotal = true # Set to true if you want a total revenue listed at the end of the graph.
hideTotals = false # If you want to see the sales total for each day on the y-axis set this to true
refreshInterval = 120 # Set as seconds. Min 5, default 120
scaleTo = 1 # Set scale size i.e. 1000 to show 8 as 8000

# Where you want to output the file on your computer. I recommend Dropbox since it can be publicly accessible.
outputFile = "/Users/domster83/Dropbox/Public/RescueBoard/rescueboard.json"

########################################
# The Guts
########################################

# http://www.misuse.org/science/2008/03/27/converting-numbers-or-currency-to-comma-delimited-format-with-ruby-regex/
def comma_numbers(number, delimiter = ',')
  number.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse
end

startDate = (Date.today - 7).strftime("%Y-%m-%d")
endDate = (Date.today - 1).strftime("%Y-%m-%d")
months = {
    "1" => "Jan",
    "2" => "Feb",
    "3" => "Mar",
    "4" => "Apr",
    "5" => "May",
    "6" => "Jun",
    "7" => "Jul",
    "8" => "Aug",
    "9" => "Sep",
    "10" => "Oct",
    "11" => "Nov",
    "12" => "Dec"
}
datasequences = []
minTotal = 0
maxTotal = 1
# puts "--> Fetching RescueTime Data"
lastDate = []

response = HTTParty.get("https://www.rescuetime.com/anapi/daily_summary_feed?key=#{apiKey}")

productivity = response.parsed_response[0]["productivity_pulse"]
totalHours = response.parsed_response[0]["total_duration_formatted"]

