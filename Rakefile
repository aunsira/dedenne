require_relative 'app'
require_relative 'config/resque'
require 'resque'
require 'redis'
Resque.redis = Redis.new(url: Config.redis_url) || Config.local_redis
require 'resque/tasks'
