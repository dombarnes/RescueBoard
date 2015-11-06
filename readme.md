# RescueBoard

A selection of widgets for [Statusboard from Panic](http://www.panic.com/statusboard) with support for [RescueTime](http://www.rescuetime.com) and [AppFigures](http://appfigures.com).

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)  

## Requirements
- Ruby 2.2
- Sinatra 1.4.5
- Gems
    - ERB
    - JSON
    - HTTParty

## Installation
### Heroku
1. Deploy directly to Heroku using the button above.
2. Obtain a RescueTime API key from http://rescuetime.com/anapi/manage
3. Add your Statusboard widget with https://yourappname.herokuapps.com/

#### ENV Vars
You need to set some ENV VARS to pass your API keys and passwords. If you're using Heroku:  
````
heroku config:keys RESCUEBOARD_API_KEY=abcdefghikj \
AF_USERNAME=name@example.com \
AF_PASSWORD=password \
AF_CLIENT_KEY=abcdefghijk
````

### Local Development
1. ````git clone https://github.com/dombarnes/RescueBoard.git && cd RescueBoard````
2. ```bundle install```
3. Configure your products in ````config/products.rb````
3. ```foreman start```
4. Set ENV Vars in your shell environment or in .env or .powenv
5. Open [http://localhost:5001]()


## Endpoints  
#### /rescuetime/pulse  
Displays the latest productivity information from your feed. This is currently limited to the previous day's data by the RescueTime API.  

![RescueBoard widget](https://raw.githubusercontent.com/dombarnes/RescueBoard/master/Rescueboard.png "RescueBoard widget")

#### /appstore/downloads  
Displays [AppFigures](http://appfigures.com) sales data. You can add query strings to specify the chart type and number of days to use. Defaults to 7 day line  
Example  
````
/appstore/downloads?type=line&days=10
````
##### Options
type: line or bar

#### /appstore/sales  
Displays [AppFigures](http://appfigures.com) sales data. You can add query strings to specify the chart type and number of days to use. Defaults to 7 day line  
Example  
````
/appstore/sales?type=line&days=10
````
##### Options
type: line or bar

## Future Development
- App Store revenue widget
- RescueTime productivity chart
