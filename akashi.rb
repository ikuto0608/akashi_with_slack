# frozen_string_literal: true

class Akashi
  include HTTParty
  base_uri 'https://atnd.ak4.jp/api/cooperation'

  attr_reader :user_id

  CHECK_IN = 11
  CHECK_OUT = 12

  def initialize(user_id)
    @user_id = user_id
  end

  def reissue_token
    self.class.post(
      "#{self.class.base_uri}/token/reissue/#{AkashiWithSlack::Config::AKASHI_COMPANY_ID}",
      {
        body: { token: user_token }
      }
    )
  end

  def check_in
    self.class.post(
      "#{self.class.base_uri}/#{AkashiWithSlack::Config::AKASHI_COMPANY_ID}/stamps",
      body: {
        token: user_token,
        type: CHECK_IN
      }
    )
  end

  def check_out
    self.class.post(
      "#{self.class.base_uri}/#{AkashiWithSlack::Config::AKASHI_COMPANY_ID}/stamps",
      body: {
        token: user_token,
        type: CHECK_OUT
      }
    )
  end

  private

  def user_token
    @user_token ||= redis.get(user_id)
  end

  def redis
    @redis ||= Redis.new(url: ENV['REDIS_URL'])
  end
end
