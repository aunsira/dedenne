class Config
  def self.redis_url
    "redis://:#{ENV['REDIS_PASSWORD']}@#{ENV['REDIS_PORT_6379_TCP_ADDR']}:#{ENV['REDIS_PORT_6379_TCP_PORT']}"
  end
end
