require 'rubygems'
require 'sinatra'

configure do
	# This array contains a hash for each product. The :title should be your product name.
	# The :id is the App Figures product ID. You can fetch this at https://api.appfigures.com/v2/products/mine
	# The :color can be red, blue, green, yellow, orange, purple, aqua, or pink
	set :products, [
			{ :title => "Trilby Training", :id => 5954125798, :color => "aqua" },
    		{ :title => "TTV", :id => 36376562723, :color => "green" },
    		# { :title => "TTV Player", :id => 36376203818, :color => "red" },
    		{ :title => "BookClub", :id => 40014607864, :color => "yellow" },
    		{ :title => "Supporting Teachers", :id => 40189399639, :color => "blue" },
    		{ :title => "Snappt", :id => 40304598815, :color => "red" }					
    	]
end
