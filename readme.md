# RescueBoard

RescueBoard is a widget for [Statusboard from Panic](http://www.panic.com/statusboard) to display your productivity results from the previous day.  

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)  

![RescueBoard widget](http://github.com/dombarnes/rescueboard/rescueboard.png "RescueBoard widget")

## Endpoints  
/latest - Displays the latest productivity information from your feed. This is currently limited to the previous day's data by the RescueTime API.  

## Requirements
- Ruby 2.2
- Sinatra 1.4.5
- Gems
    - ERB
    - JSON
    - HTTParty


## Future Development
- Add endpoints for last weeks data for a graph widget (optional line or bar)