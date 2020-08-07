# frozen_string_literal: true

set :logger, Logger.new(STDOUT)

post '/' do
  token = params.delete('token')
  logger.info params

  return status 403 if token != AkashiWithSlack::Config::SLACK_TOKEN
  return status 403 if params['command'] != AkashiWithSlack::Config::COMMAND_NAME

  action, user_token = params['text'].split(' ')

  case action
  when AkashiWithSlack::Command::INIT
    return SlackResponse.new.message('トークンが見つかりませんでした。') if user_token.nil?

    redis = Redis.new(url: ENV['REDIS_URL'])
    redis.set(params['user_id'], user_token)

    SlackResponse.new.init_message
  when AkashiWithSlack::Command::CHECK_IN
    akashi = Akashi.new(params['user_id'])
    res = akashi.check_in

    SlackResponse.new(res).akashi_message
  when AkashiWithSlack::Command::CHECK_OUT
    akashi = Akashi.new(params['user_id'])
    res = akashi.check_out

    SlackResponse.new(res).akashi_message
  when AkashiWithSlack::Command::HELP
    SlackResponse.new.help_message
  else
    SlackResponse.new.help_message
  end
end
