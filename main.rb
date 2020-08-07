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
    redis.set(
      params['user_id'],
      {
        user_token: user_token,
        expired_at: Time.now + (30 * 24 * 60 * 60)
      }.to_json
    )

    json(
      SlackResponse.new.init_message,
      encoder: :to_json,
      content_type: :json
    )
  when AkashiWithSlack::Command::CHECK_IN
    akashi = Akashi.new(params['user_id'])
    res = akashi.check_in

    akashi.reissue_token! if akashi.expires_soon?

    json(
      SlackResponse.new(res).akashi_message,
      encoder: :to_json,
      content_type: :json
    )
  when AkashiWithSlack::Command::CHECK_OUT
    akashi = Akashi.new(params['user_id'])
    res = akashi.check_out

    akashi.reissue_token! if akashi.expires_soon?

    json(
      SlackResponse.new(res).akashi_message,
      encoder: :to_json,
      content_type: :json
    )
  else
    json(
      SlackResponse.new.help_message,
      encoder: :to_json,
      content_type: :json
    )
  end
end
