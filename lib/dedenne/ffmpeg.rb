require 'streamio-ffmpeg'
require 'fileutils'

module Dedenne

  $bitrates = {
    480  => '900',
    720  => '1800',
    1080 => '3000'
  }

  class FFMPEGHLS
    attr_accessor :video, :path
    TRANSCODE_SALT = "3a4a7575f0e31d2c2275"

    def initialize(file_video)
      @video = FFMPEG::Movie.new(file_video)

      puts @video.valid?
      puts "Audio stream :: " + @video.audio_stream
      puts "Video codec  :: " + @video.video_codec
      puts "Resolution   :: " + @video.resolution

      course_id  = "123"
      chapter_id = "2"
      version    = "-1"
      hash       = Digest::SHA1.hexdigest("#{TRANSCODE_SALT}-#{course_id}-#{chapter_id}#{version}")

      # Create 'video' folder if not exists
      @path = File.expand_path("/Users/aun/code/git/dedenne/video/#{course_id}/#{chapter_id}#{version}/#{hash}/", Dir.pwd)
      FileUtils.mkdir_p(@path) unless File.exists? @path
    end

    def from_mp4_to_hls
      $bitrates.each do |quality, bitrate|
        FileUtils.cp File.expand_path("/Users/aun/code/git/dedenne/hls_#{quality}p_.key"), File.expand_path("#{@path}/hls_#{quality}p_.key")

        segment_file  = File.expand_path("#{@path}/hls_#{quality}p_")
        output_file   = segment_file + ".m3u8"
        key_info_file = "hls_#{quality}p_.keyinfo"

        options = {
          custom: %W( -b:v #{bitrate}k
                      -s 1920x1080
                      -c:v libx264
                      -x264-params keyint=25:no-scenecut=1
                      -hls_time 1
                      -hls_list_size 0
                      -hls_segment_filename #{segment_file}%03d.ts
                      -hls_key_info_file #{key_info_file}
                      -r 30
                      -maxrate 250k
                      -b:a 128k
                      -f hls )
        }

        transcoder_options = { validate: false }
        puts "+++++++++ Start transcoding +++++++++++++"
        @video.transcode(output_file, options, transcoder_options) do |progress|
          puts progress
        end

        generate_index_files_for quality
        puts "+++++++++++++ Transcoded ++++++++++++++"
      end
    end

    def generate_index_files_for quality
      FileUtils.touch("#{@path}/index.m3u8")
      File.open("#{@path}/#{quality}p.m3u8", 'w') { |file| file.write("hls_#{quality}p_.m3u8") }
      File.open("#{@path}/index.m3u8", 'a') { |file| file <<  "hls_#{quality}p_.m3u8\n" }
    end
  end
end