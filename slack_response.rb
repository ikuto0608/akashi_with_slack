class SlackResponse
  attr_reader :akashi_response

  HELP_MESSAGE = <<EOF
コマンド一覧
```
- /akashide init YOUR_TOKEN
- /akashide in
- /akashide out
- /akashide help
```
in:出勤 / out:退勤
*YOUR_TOKEN* はAkashiの<https://atnd.ak4.jp/mypage/tokens|ウェブサイト>から取得したトークンに置き換えてください
EOF

  def initialize(akashi_response = {})
    @akashi_response = akashi_response
  end

  def message(text)
    text
  end

  def akashi_message
    if akashi_response['success']
      { text: ENV['SUCCESS_MESSAGE'], response_type: 'in_channel' }
    else
      {
        text: "打刻に失敗しました。。 (#{akashi_response['errors']})"
      }.to_json
    end
  end

  def init_message
    { text: '打刻する準備ができました！' }
  end

  def help_message
    { text: HELP_MESSAGE }
  end
end
