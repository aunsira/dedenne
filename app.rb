require 'sinatra'
require 'resque'
require_relative 'lib/dedenne'
require_relative 'lib/dedenne/transcoder_queue'
require_relative 'config/resque'

set :bind, '0.0.0.0'

get '/transcode/course/:course_id/chapter/:chapter_id' do
  course_id     = params['course_id']
  chapter_id    = params['chapter_id']
  upload_bucket = params['upload_bucket']
  transcoded_bucket = params['transcoded_bucket']
  video_version = params['version'].empty? ? "" : "-#{params['version']}"
  host = params['host']

  Resque.enqueue(TranscoderQueue, course_id, chapter_id, video_version, upload_bucket, transcoded_bucket, host)
end
