require 'sinatra'
require './lib/dedenne'

get '/transcode/course/:course_id/chapter/:chapter_id' do
  "Course id: #{params['course_id']}, Chapter id: #{params['chapter_id']}"
  course_id  = params['course_id'] || nil
  chapter_id = params['chapter_id'] || nil
  Dedenne::transcode(course_id, chapter_id)
end
