require 'streamio-ffmpeg'
require 'fileutils'

FileUtils.mkdir('./files') unless File.exists? './files'
FileUtils.cp './file.key', './files/file.key'

video = FFMPEG::Movie.new(ARGV[0])

puts video.valid?
puts "Audio stream :: " + video.audio_stream
puts "Video codec :: " + video.video_codec
puts "Resolution :: " +  video.resolution

bitrates = {
  480 => '900',
  720 => '1800',
  1080 => '3000'
}

bitrates.each do |quality, bitrate|
  segment_file = "./files/out_#{quality}"
  output_file = segment_file + ".m3u8"

  options = {
    custom: %W( -b:v #{bitrate}k
                -s 1920x1080
                -c:v h264
                -hls_time 1
                -hls_list_size 0
                -hls_segment_filename #{segment_file}_%03d.ts
                -hls_key_info_file file.keyinfo
                -r 30
                -f hls )
  }

  transcoder_options = { validate: false }
  video.transcode(output_file, options, transcoder_options) do |progress|
    puts progress
  end
end

