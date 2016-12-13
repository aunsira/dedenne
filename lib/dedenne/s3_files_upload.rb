require 'aws-sdk'
require 'etc'
require 'fileutils'

module Dedenne

  class S3FilesUpload
    TRANSCODE_SALT = "3a4a7575f0e31d2c2275"
    HOME_PATH = Etc.getpwuid.dir

    def initialize()
      Aws.config.update({
        credentials: Aws::Credentials.new(ENV['AWS_S3_ACCESS_KEY_ID'], ENV['AWS_S3_SECRET_ACCESS_KEY']),
        region: 'ap-southeast-1'
      })
    end

    def upload!(course_id, chapter_id, video_version)
      s3 = Aws::S3::Resource.new
      hash = Digest::SHA1.hexdigest("#{TRANSCODE_SALT}-#{course_id}-#{chapter_id}#{video_version}")

      files_in_folder = Dir.glob(HOME_PATH + "/video/#{course_id}/#{chapter_id}#{video_version}/#{hash}/*")
      files_in_folder.each do |filename|
        file = File.open(filename)
        s3.bucket(ENV["AWS_S3_VIDEO_TRANSCODED_BUCKET"]).object("#{filename.gsub(HOME_PATH + "/", "")}").put(file, {body: file, acl: "public-read"} )
      end

      update_transcode_status! chapter_id

      puts "============== Transcoded video files of course: #{course_id}, chapter_id: #{chapter_id} have been uploaded ==============="

      # Remove local video files
      FileUtils.rm_rf(HOME_PATH + "/video/#{course_id}/") if File.exists?(HOME_PATH + "/video/#{course_id}/")
      puts "============== Removed local video files =================="
    end

    def get_video_file(course_id, chapter_id, video_version)
      s3 = Aws::S3::Resource.new
      path = "video/#{course_id}/#{chapter_id}#{video_version}.mp4"
      download_path = HOME_PATH + "/video/#{course_id}/"
      FileUtils.mkdir_p(download_path) unless File.exists? download_path
      s3_obj = s3.bucket(ENV["AWS_S3_UPLOADS_BUCKET"]).object("#{path}").get(response_target: "#{download_path}#{chapter_id}#{video_version}.mp4")
    end

    def update_transcode_status!(chapter_id)
      uri           =  URI.parse("#{ENV['HOST']}")
      https         =  Net::HTTP.new(uri.host, uri.port)
      https.use_ssl =  true
      https.send_request('PATCH', "/api/transcoder/chapters/#{chapter_id}/complete")
    end
  end
end
