require File.expand_path '../spec_helper.rb', __FILE__

describe '#POST' do
  context 'init action' do
    let!(:params) { { text: 'init USER_TOKEN', command: 'akashide' }.to_json }
  end

  context 'check in action' do
    let!(:params) { { text: 'in', command: 'akashide' }.to_json }
  end

  context 'check out action' do
    let!(:params) { { text: 'out', command: 'akashide' }.to_json }
  end

  context 'help action' do
    let!(:params) { { text: 'help', command: 'akashide' }.to_json }
    let!(:expected_json) {
      {
        text: <<EOF
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
      }
    }

    it 'returns expected response' do
      post '/', params
      expect(last_response.status).to eq(200)
    end
  end

  context 'when having empty params' do
    let!(:params) { {}.to_json }

    it 'returns 403' do
      post '/', params
      expect(last_response.status).to eq(403)
    end
  end

  context 'when token unmatched' do
    let!(:params) { { token: 'UNMATCHED_TOKEN' }.to_json }

    it 'returns 403' do
      post '/', params
      expect(last_response.status).to eq(403)
    end
  end

  context 'when having invalid command name' do
    let!(:params) { { command: 'invalid_command' }.to_json }

    it 'returns 403' do
      post '/', params
      expect(last_response.status).to eq(403)
    end
  end
end
