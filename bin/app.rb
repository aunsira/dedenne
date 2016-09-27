require 'sinatra'
require './lib/dedenne'

get '/transcode/course/:course_id/chapter/:chapter_id' do
  course_id     = params['course_id']
  chapter_id    = params['chapter_id']
  video_version = params['version'] || 1
  Dedenne::transcode(course_id, chapter_id, video_version)
end
