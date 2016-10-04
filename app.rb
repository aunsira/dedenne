require 'sinatra'
require_relative 'lib/dedenne'

set :bind, '0.0.0.0'

get '/transcode/course/:course_id/chapter/:chapter_id' do
  course_id     = params['course_id']
  chapter_id    = params['chapter_id']
  video_version = "-#{params['version']}" || ""
  Dedenne::transcode(course_id, chapter_id, video_version)
  "Done!"
end
