require "dedenne/transcoder"

module Dedenne
  class TranscoderQueue
    @queue = :transcode

    def self.perform(course_id, chapter_id, video_version, app_name)
      Transcoder.new(course_id, chapter_id, video_version, app_name)
                .transcode
    end
  end
end
