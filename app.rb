require 'sinatra'
require 'resque'
require_relative 'lib/dedenne'
require_relative 'lib/dedenne/params_queue'

set :bind, '0.0.0.0'

get '/transcode/course/:course_id/chapter/:chapter_id' do
  course_id     = params['course_id']
  chapter_id    = params['chapter_id']
  video_version = "-#{params['version']}" || ""
  Resque.enqueue(TranscoderQueue, course_id, chapter_id, video_version)
end
