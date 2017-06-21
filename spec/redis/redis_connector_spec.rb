require 'spec_helper'

describe RedisConnector do
  describe 'Redis' do
    it 'can connect to redis' do
      redis = RedisConnector.new
      expect(redis.connect).to be_a Redis
    end
  end
end
