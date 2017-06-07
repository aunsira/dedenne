require_relative 'app'
require 'default_config'
require 'resque'
require 'redis'
require 'resque/tasks'
require 'redis_connector'
Resque.redis = RedisConnector.new.connect
