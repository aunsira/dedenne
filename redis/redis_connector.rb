require 'default_config'
require 'redis'

class RedisConnector
  attr_reader :redis_url

  def initialize
    @redis_url = DefaultConfig.new.redis_url
  end

  def connect
    Redis.new(url: redis_url)
  end
end
