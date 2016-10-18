class Config
  def self.redis_url
    if ENV['REDIS_PORT_6379_TCP_ADDR'] && ENV['REDIS_PORT_6379_TCP_PORT']
      return ENV['REDIS_PORT_6379_TCP_ADDR'] + ":" + ENV['REDIS_PORT_6379_TCP_PORT']
    end
  end

  def self.local_redis
    'localhost:6379'
  end
end
