require 'sinatra'
require 'resque'
require 'redis_connector'
require 'dedenne'

set :bind, '0.0.0.0'

get '/transcode/course/:course_id/chapter/:chapter_id' do
  course_id     = params['course_id']
  chapter_id    = params['chapter_id']
  video_version = params['version'].empty? ? "" : "-#{params['version']}"
  app_name      = params['app_name']

  Resque.redis = RedisConnector.new.connect
  Resque.enqueue(Dedenne::TranscoderQueue, course_id, chapter_id, video_version, app_name)
end
