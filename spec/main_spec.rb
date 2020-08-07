require File.expand_path '../spec_helper.rb', __FILE__

describe '#POST' do
  let!(:default_params) {
    'command=/akashide&token=SLACK_TOKEN&user_id=ABC123'
  }

  before(:each) { allow(Redis).to receive(:new).and_return(MockRedis.new) }

  context 'init action' do
    let!(:params) { default_params + '&text=init USER_TOKEN' }
    let!(:expected_json) { { 'text' => '打刻する準備ができました！' } }

    it 'returns expected response' do
      post '/', params
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq(expected_json)
    end
  end

  context 'check in action' do
    let!(:params) { default_params + '&text=in' }
    let!(:expected_json) { { 'text' => ENV['SUCCESS_MESSAGE'], 'response_type' => 'in_channel' } }

    it 'returns expected response' do
      VCR.use_cassette 'succeeded_check_in' do
        post '/', params
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq(expected_json)
      end
    end
  end

  context 'check out action' do
    let!(:params) { default_params + '&text=out' }
    let!(:expected_json) { { 'text' => ENV['SUCCESS_MESSAGE'], 'response_type' => 'in_channel' } }

    it 'returns expected response' do
      VCR.use_cassette 'succeeded_check_out' do
        post '/', params
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq(expected_json)
      end
    end
  end

  context 'help action' do
    let!(:params) { default_params + '&text=help' }
    let!(:expected_json) {
      {
        'text' => <<EOF
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
      }
    }

    it 'returns expected response' do
      post '/', params
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq(expected_json)
    end
  end

  context 'when having empty params' do
    let!(:params) { '' }

    it 'returns 403' do
      post '/', params
      expect(last_response.status).to eq(403)
    end
  end

  context 'when token unmatched' do
    let!(:params) { 'token=UNMATCHED_TOKEN' }

    it 'returns 403' do
      post '/', params
      expect(last_response.status).to eq(403)
    end
  end

  context 'when having invalid command name' do
    let!(:params) { 'command=invalid_command' }

    it 'returns 403' do
      post '/', params
      expect(last_response.status).to eq(403)
    end
  end
end
