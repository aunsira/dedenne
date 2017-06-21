require 'digest/sha1'
require 'etc'
require 'fileutils'
require 'streamio-ffmpeg'
require 'default_config'

module Dedenne
  class VideoProcessor
    attr_accessor :storage_service, :video, :config

    HOME_PATH = Etc.getpwuid.dir

    def initialize(storage_service)
      @storage_service = storage_service
      @config          = DefaultConfig.new
      @video           = FFMPEG::Movie.new(HOME_PATH + '/' + storage_service.original_video_path)
    end

    def prepare_stuff
      generate_key_files
      FileUtils.touch("#{video_path}/index.m3u8")
      File.open("#{video_path}/index.m3u8", 'a') { |file| file.puts '#EXTM3U' }
    end

    def mp4_to_hls
      config.bitrates.each do |quality, bitrate|
        FileUtils.cp File.expand_path(Dir.pwd + "/hls_#{quality}p_.key"), File.expand_path("#{video_path}/hls_#{quality}p_.key")

        segment_file  = File.expand_path("#{video_path}/hls_#{quality}p_")
        output_file   = segment_file + '.m3u8'
        key_info_file = "hls_#{quality}p_.keyinfo"

        hls_options = {
          custom: %W( -b:v #{bitrate}k
                      -s #{video.resolution}
                      -c:v libx264
                      -preset fast
                      -x264-params keyint=25:no-scenecut=1
                      -hls_time 1
                      -hls_list_size 0
                      -hls_segment_filename #{segment_file}%03d.ts
                      -hls_key_info_file #{key_info_file}
                      -hls_allow_cache 1
                      -segment_list_flags cache
                      -r 30
                      -maxrate 250k
                      -b:a 128k
                      -f hls )
        }
        transcoder_options = { validate: false }

        video.transcode(output_file, hls_options, transcoder_options)

        generate_index_files_for(quality, bitrate, video.resolution)
      end
    end

    def video_path
      path = File.expand_path(HOME_PATH + "/video/#{storage_service.course_id}/#{storage_service.chapter_id}#{storage_service.video_version}/#{storage_service.hash}/", Dir.pwd)
      FileUtils.mkdir_p(path) unless File.exist? path
      path
    end

    private

      def generate_key_files
        system './initkey.sh'
      end

      def generate_index_files_for(quality, bitrate, resolution)
        File.open("#{video_path}/#{quality}p.m3u8", 'w') do |file|
          file.puts '#EXTM3U'
          file.puts %(#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=#{bitrate.to_i * 1024},RESOLUTION=#{resolution},CODECS="avc1.4d0029,mp4a.40.2")
          file.puts "hls_#{quality}p_.m3u8"
        end
        File.open("#{video_path}/index.m3u8", 'a') do |file|
          file.puts %(#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=#{bitrate.to_i * 1024},RESOLUTION=#{resolution},CODECS="avc1.4d0029,mp4a.40.2")
          file.puts "hls_#{quality}p_.m3u8"
        end
      end
  end
end
