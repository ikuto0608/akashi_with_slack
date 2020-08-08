# frozen_string_literal: true

require 'time'

class Akashi
  include HTTParty
  base_uri 'https://atnd.ak4.jp/api/cooperation'

  attr_reader :user_id

  CHECK_IN = 11
  CHECK_OUT = 12

  def initialize(user_id)
    @user_id = user_id
  end

  def reissue_token!
    res = self.class.post(
      "#{self.class.base_uri}/token/reissue/#{AkashiWithSlack::Config::AKASHI_COMPANY_ID}",
      body: { token: user_token }
    )

    redis.set(
      user_id,
      {
        user_token: res['response']['token'],
        expired_at: res['response']['expired_at']
      }.to_json
    )
  end

  def expires_soon?
    expired_at < Time.now + (10 * 24 * 60 * 60)
  end

  def check_in!
    stamp(CHECK_IN)
  end

  def check_out!
    stamp(CHECK_OUT)
  end

  def stamp(type)
    self.class.post(
      "#{self.class.base_uri}/#{AkashiWithSlack::Config::AKASHI_COMPANY_ID}/stamps",
      body: {
        token: user_token,
        type: type
      }
    )
  end

  private

  def user_token
    cached_user_hash['user_token']
  end

  def expired_at
    Time.parse(cached_user_hash['expired_at'])
  end

  def cached_user_hash
    @cached_user_hash ||= JSON.parse(redis.get(user_id) || '{}')
  end

  def redis
    @redis ||= Redis.new(url: ENV['REDIS_URL'])
  end
end
