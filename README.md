# akashi_with_slack

This sinatra app allows you to check in/out on [AKASHI](https://atnd.ak4.jp/) from Slack.

### Deploy to Heroku
```
cd /path/to/akashi_with_slack
heroku create
git push heroku master
```
- Set these environemnet variables; `AKASHI_COMPANY_ID` & `SLACK_TOKEN` & `SUCCESS_MESSAGE` in Heroku's Config Vars
- Add redis as Heroku's Add-ons

### Slack configuration
Create your app in https://api.slack.com/apps which configures a slash command,
```
Command: /akashide
Request URL: YOUR HEROKU APP URL
Short Description: Manage checking in/out on AKASHI
Usage Hint: help [or init, in, out]
```
This app has to have *commands permission* .
