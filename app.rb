#!/usr/bin/env ruby

# RescueTime Productivity Widget for Statusboard
require 'rubygems'
require 'sinatra'
require 'erb'
require 'httparty'

# Tilt.register Tilt::ERBTemplate, 'html.erb'

before do
    
end

def get_results
    apiKey = "B63GP9AzVAG6fRMPQOBfW9HkqJT8BMwtBwALl7lc"
    response = HTTParty.get("https://www.rescuetime.com/anapi/daily_summary_feed?key=#{apiKey}")
    productivityPulse = response.parsed_response[0]["productivity_pulse"]
    totalHours = response.parsed_response[0]["total_duration_formatted"]
end

get '/' do
    get_results
    erb :index, :locals => {:productivityPulse => params[:productivityPulse], :totalHours => params[:totalHours]}
end