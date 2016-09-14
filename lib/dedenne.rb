require 'streamio-ffmpeg'
require 'fileutils'

module Dedenne
  def transcode(video)
    transcoded_video_files = File.expand_path("./files/", Dir.pwd)
    FileUtils.mkdir(transcoded_video_files) unless File.exists? transcoded_video_files

    video = FFMPEG::Movie.new(video)

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
      FileUtils.cp File.expand_path("./hls_#{quality}.key"), File.expand_path("./files/hls_#{quality}.key")

      segment_file = File.expand_path("./files/hls_#{quality}")
      output_file = segment_file + ".m3u8"
      key_info_file = "hls_#{quality}.keyinfo"

      options = {
        custom: %W( -b:v #{bitrate}k
                    -s 1920x1080
                    -c:v h264
                    -hls_time 1
                    -hls_list_size 0
                    -hls_segment_filename #{segment_file}_%03d.ts
                    -hls_key_info_file #{key_info_file}
                    -r 30
                    -f hls )
      }

      transcoder_options = { validate: false }
      video.transcode(output_file, options, transcoder_options) do |progress|
        puts progress
      end
    end
  end

  module_function :transcode

end

