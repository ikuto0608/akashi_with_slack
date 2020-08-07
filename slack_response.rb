class SlackResponse
  attr_reader :akashi_response

  HELP_MESSAGE = <<EOF
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

  def initialize(akashi_response = {})
    @akashi_response = akashi_response
  end

  def message(text)
    { text: text }.to_json
  end

  def akashi_message
    puts akashi_response
    if akashi_response['success']
      { text: '打刻成功！', response_type: 'in_channel' }
    else
      {
        text: "打刻に失敗しました。。 (#{akashi_response['errors']})"
      }.to_json
    end
  end

  def init_message
    { text: '打刻する準備ができました！' }.to_json
  end

  def help_message
    { text: HELP_MESSAGE }.to_json
  end
end
