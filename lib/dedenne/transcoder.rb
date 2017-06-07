require 'dedenne/request_handler'
require 'dedenne/storage_service'
require 'dedenne/video_processor'

require 'default_config'

module Dedenne
  class Transcoder
    attr_reader :course_id, :chapter_id, :video_version, :app_name

    def initialize(course_id, chapter_id, video_version, app_name)
      @course_id     = course_id
      @chapter_id    = chapter_id
      @video_version = video_version
      @app_name      = app_name
    end

    def transcode
      update_complete_status and return if already_transcoded?

      storage_service.get_video_file

      video_processor.prepare_stuff
      video_processor.mp4_to_hls

      request_handler.update_video_duration(video_processor.video.duration)

      storage_service.upload
    end

    private

      def storage_service
        @storage_service ||= StorageService.new(course_id, chapter_id, video_version, app_name)
      end

      def video_processor
        @video_processor ||= VideoProcessor.new(storage_service)
      end

      def request_handler
        @request_handler ||= RequestHandler.new(chapter_id, storage_service.host)
      end

      def config
        @config ||= DefaultConfig.new
      end

      def update_complete_status
        request_handler.update_transcode_status(config.transcode_status[:complete])
      end

      def already_transcoded?
        # For rspec test
        return false if ENV['RACK_ENV'] == 'test'

        storage_service.already_transcoded?
      end
  end
end
