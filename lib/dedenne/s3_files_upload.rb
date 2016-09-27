require 'aws-sdk'
require 'fileutils'

module Dedenne

  class S3FilesUpload
    def initialize()
      Aws.config.update({
        credentials: Aws::Credentials.new(ENV['AWS_KEY_ID'], ENV['AWS_SECRET']),
        region: 'ap-southeast-1'
      })
    end

    def upload!
      s3 = Aws::S3::Resource.new
      files_in_folder = Dir.glob("video/*/*/*/*")
      puts "#{files_in_folder}"
      files_in_folder.each do |filename|
        file = File.open(filename)
        s3.bucket('skilllane-transcoder-test').object("#{filename}").put(file, {body: file} )
      end
      puts "Uploaded!"
    end

    def get_video_file(course_id, chapter_id, video_version)
      s3 = Aws::S3::Resource.new
      path = "video/#{course_id}/#{chapter_id}#{video_version}.mp4"
      download_path = "/Users/aun/Downloads/video/#{course_id}/"
      FileUtils.mkdir_p(download_path) unless File.exists? download_path
      s3_obj = s3.bucket('skilllane-transcoder-test').object("#{path}").get(response_target: "#{download_path}#{chapter_id}#{video_version}.mp4")
    end

  end
end
