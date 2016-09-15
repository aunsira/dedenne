require 'dedenne/s3_files_upload'
require 'dedenne/ffmpeg'
require 'streamio-ffmpeg'
require 'fileutils'

module Dedenne
  def transcode(video)
    ffmpeg = FFMPEGHLS.new(video)
    ffmpeg.from_mp4_to_hls

    uploader = S3FilesUpload.new()
    uploader.upload!
  end

  module_function :transcode

end

