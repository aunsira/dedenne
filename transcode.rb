require 'streamio-ffmpeg'

video = FFMPEG::Movie.new("/Users/aun/Downloads/SampleVideo_1280x720_5mb.mp4")

puts video.valid?
puts "Audio stream :: " + video.audio_stream
puts "Video codec :: " + video.video_codec
puts "Resolution :: " +  video.resolution

options = {
custom: %w(-s 1920x1080 -c:v libx264 -hls_flags delete_segments -hls_key_info_file file.keyinfo)
}

transcoder_options = { validate: false }
video.transcode("/Users/aun/tmp/transcode/files/transcoded.m3u8", options, transcoder_options) do |progress|
  puts progress
end

video = FFMPEG::Movie.new("/Users/aun/tmp/transcode/files/transcoded.m3u8")

puts "Audio stream :: " + video.audio_stream.to_s
puts "Video codec :: " + video.video_codec.to_s
puts "Resolution :: " +  video.resolution.to_s

