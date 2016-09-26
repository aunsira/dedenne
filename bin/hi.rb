require 'sinatra'
require './lib/dedenne'

get '/' do
  'hello world'
  Dedenne::transcode(ARGV[0])
end
