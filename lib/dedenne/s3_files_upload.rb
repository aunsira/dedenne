require 'aws-sdk'
require 'etc'
require 'fileutils'

module Dedenne

  class S3FilesUpload
    TRANSCODE_SALT = "3a4a7575f0e31d2c2275"
    HOME_PATH = Etc.getpwuid.dir

    def initialize()
      Aws.config.update({
        credentials: Aws::Credentials.new(ENV['AWS_KEY_ID'], ENV['AWS_SECRET']),
        region: 'ap-southeast-1'
      })
    end

    def upload!(course_id, chapter_id, video_version)
      s3 = Aws::S3::Resource.new
      hash = Digest::SHA1.hexdigest("#{TRANSCODE_SALT}-#{course_id}-#{chapter_id}#{video_version}")

      files_in_folder = Dir.glob(HOME_PATH + "/video/#{course_id}/#{chapter_id}#{video_version}/#{hash}/*")
      puts "#{files_in_folder}"
      files_in_folder.each do |filename|
        file = File.open(filename)
        s3.bucket('skilllane-transcoder-test').object("#{filename}").put(file, {body: file, acl: "public-read"} )
      end

      url = "#{ENV['SKL_HOST']}/api/transcoder/update_transcode_status.json?chapter_id=#{chapter_id}"
      uri = URI(url)
      Net::HTTP.get(uri)
      puts "Uploaded!"
    end

    def get_video_file(course_id, chapter_id, video_version)
      s3 = Aws::S3::Resource.new
      path = "video/#{course_id}/#{chapter_id}#{video_version}.mp4"
      download_path = HOME_PATH + "/video/#{course_id}/"
      FileUtils.mkdir_p(download_path) unless File.exists? download_path
      s3_obj = s3.bucket('skilllane-transcoder-test').object("#{path}").get(response_target: "#{download_path}#{chapter_id}#{video_version}.mp4")
    end

  end
end
