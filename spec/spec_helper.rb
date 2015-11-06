require_relative '../app.rb'
require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
ENV['RACK_ENV'] = 'test'

describe 'RescueBoard' do
    include Rack::Test::Methods

    def app
        Sinatra::Application
    end

    it "returns a 200 status code" do
        get '/appstore/downloads' do
            expect(last_response).to be_ok
        end
    end
end
