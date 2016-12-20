require_relative 'dedenne/s3_files_upload'
require_relative 'dedenne/ffmpeg'
require 'streamio-ffmpeg'
require 'fileutils'

module Dedenne
  def transcode(course_id, chapter_id, video_version, upload_bucket, transcoded_bucket, host)
    uploader = S3FilesUpload.new(upload_bucket, transcoded_bucket, host)
    uploader.get_video_file(course_id, chapter_id, video_version)

    ffmpeg = FFMPEGHLS.new(course_id, chapter_id, video_version)
    ffmpeg.from_mp4_to_hls
    ffmpeg.update_video_duration!(host)

    uploader.upload!(course_id, chapter_id, video_version)
  end

  module_function :transcode

end

