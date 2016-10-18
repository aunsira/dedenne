require_relative 'app'
require_relative 'config/resque'
require 'resque'
Resque.redis = Config.redis_url || Config.local_redis
require 'resque/tasks'
