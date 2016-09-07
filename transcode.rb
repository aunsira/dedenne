require 'streamio-ffmpeg'

video = FFMPEG::Movie.new("/Users/aun/Downloads/SampleVideo_1280x720_5mb.mp4")

puts video.valid?
puts "Audio stream :: " + video.audio_stream
puts "Video codec :: " + video.video_codec
puts "Resolution :: " +  video.resolution

video.transcode("/Users/aun/tmp/transcode/transcoded.m3u8") do |progress|
  puts progress
end

