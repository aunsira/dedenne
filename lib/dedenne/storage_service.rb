require 'aws-sdk'
require 'etc'
require 'fileutils'
require 'default_config'

require 'dedenne/amazon_service'
require 'dedenne/request_handler'

module Dedenne
  class StorageService
    attr_reader :course_id, :chapter_id, :video_version, :upload_bucket,
                :transcoded_bucket, :app_name, :host, :config

    HOME_PATH = Etc.getpwuid.dir

    def initialize(course_id, chapter_id, video_version, app_name)
      @course_id     = course_id
      @chapter_id    = chapter_id
      @video_version = video_version
      @app_name      = app_name || 'skilllane'
      @config        = DefaultConfig.new
      set_bucket_from_app
    end

    def upload
      s3 = AmazonService.new.connect_s3

      files_in_folder = Dir.glob(HOME_PATH + "/video/#{course_id}/#{chapter_id}#{video_version}/#{hash}/*")
      files_in_folder.each do |filename|
        file = File.open(filename)
        s3.bucket(transcoded_bucket)
          .object(filename.gsub(HOME_PATH + '/', '').to_s)
          .put(file, body: file, acl: 'public-read')
      end

      RequestHandler.new(chapter_id, host)
                    .update_transcode_status(config.transcode_status[:complete])

      puts "============== Transcoded video files of course: #{course_id}, chapter_id: #{chapter_id} have been uploaded ==============="

      # Remove local video files
      FileUtils.rm_rf(HOME_PATH + "/video/#{course_id}/") if File.exist?(HOME_PATH + "/video/#{course_id}/")
    end

    def get_video_file
      s3 = AmazonService.new.connect_s3

      s3.bucket(upload_bucket)
        .object(original_video_path)
        .get(response_target: "#{download_path}#{chapter_id}#{video_version}.mp4")
    rescue Aws::S3::Errors::NoSuchKey
      RequestHandler.new(chapter_id, host)
                    .update_transcode_status(config.transcode_status[:error])
    end

    def original_video_path
      "video/#{course_id}/#{chapter_id}#{video_version}.mp4"
    end

    def transcoded_video_path
      "#{original_video_path.gsub('.mp4', '')}/#{hash}/index.m3u8"
    end

    def already_transcoded?
      transcoded_object = AmazonService.new.s3_object(@transcoded_bucket, transcoded_video_path)
      transcoded_object.exists?
    end

    def hash
      Digest::SHA1.hexdigest("#{config.transcode_salt}-#{course_id}-#{chapter_id}#{video_version}")
    end

    private

      def set_bucket_from_app
        if app_name.downcase == config.skilllane
          @upload_bucket     = config.skilllane_origin_bucket
          @transcoded_bucket = config.skilllane_transcoded_bucket
          @host              = config.skilllane_host
        elsif app_name.downcase == config.schoollane
          @upload_bucket     = config.schoollane_origin_bucket
          @transcoded_bucket = config.schoollane_transcoded_bucket
          @host              = config.schoollane_host
        end
      end

      def download_path
        download_path = HOME_PATH + "/video/#{course_id}/"
        FileUtils.mkdir_p(download_path) unless File.exist? download_path
        download_path
      end
  end
end
