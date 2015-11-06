require 'spec_helper'
require 'rack/test'

describe 'App Store endpoint' do
    describe 'GET /appstore/downloads' do
        it "returns a 200 status code" do
            get '/appstore/downloads'
            expect(response).to be_ok
        end
    end
end
