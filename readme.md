# RescueBoard

RescueBoard is a widget for [Statusboard from Panic](http://www.panic.com/statusboard) to display your productivity results from the previous day.  

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)  

![RescueBoard widget](https://raw.githubusercontent.com/dombarnes/RescueBoard/master/Rescueboard.png "RescueBoard widget")

## Endpoints  
/latest - Displays the latest productivity information from your feed. This is currently limited to the previous day's data by the RescueTime API.  

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
3. Set this as in your environment as RESCUEBOARD_API_KEY
4. Add your Statusboard widget with https://yourappname.herokuapps.com/latest

### Mac/Linux  

1. Clone the repo
2. Set RESCUEBOARD_API_KEY in your shell environment or in .ENV
3. Run:```bundle install```
4. Run:```foreman start```


## Future Development
- Add endpoints for last weeks data for a graph widget (optional line or bar)