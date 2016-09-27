require './lib/dedenne/s3_files_upload'
require './lib/dedenne/ffmpeg'
require 'streamio-ffmpeg'
require 'fileutils'

module Dedenne
  def transcode(course_id, chapter_id, video_version)
    uploader = S3FilesUpload.new()
    uploader.get_video_file(course_id, chapter_id, video_version)

    ffmpeg = FFMPEGHLS.new(course_id, chapter_id, video_version)
    ffmpeg.from_mp4_to_hls

    uploader.upload!
  end

  module_function :transcode

end

