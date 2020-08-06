# frozen_string_literal: true

post '/' do
  params = JSON.parse(request.body.read)

  return status 403 if params['token'] != AkashiWithSlack::Config::SLACK_TOKEN
  return status 403 if params['command'] != AkashiWithSlack::Config::COMMAND_NAME

  action, user_token = params['text'].split(' ')

  case action
  when AkashiWithSlack::Command::INIT
    params['user_id']
  when AkashiWithSlack::Command::CHECK_IN
    params['user_id']
  when AkashiWithSlack::Command::CHECK_OUT
    params['user_id']
  when AkashiWithSlack::Command::HELP
<<EOF
コマンド一覧
'''
- /akashide init YOUR_TOKEN
- /akashide in
- /akashide out
- /akashide help
'''

init: Akashiのウェブサイトから取得したトークンを一緒に送ってください
in: 出勤
out: 退勤
EOF
  else
    params['user_id']
  end
end
