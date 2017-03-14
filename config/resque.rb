class Config
  def self.redis_url
    if ENV['REDIS_PORT_6379_TCP_ADDR'] && ENV['REDIS_PORT_6379_TCP_PORT'] && ENV['REDIS_PASSWORD']
      return "redis://:#{ENV['REDIS_PASSWORD']}@#{ENV['REDIS_PORT_6379_TCP_ADDR']}:#{ENV['REDIS_PORT_6379_TCP_PORT']}"
    end
  end

  def self.local_redis
    'localhost:6379'
  end
end
