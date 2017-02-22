require 'aws-sdk'
require 'etc'
require 'fileutils'

module Dedenne

  class S3FilesUpload
    TRANSCODE_SALT = "3a4a7575f0e31d2c2275"
    HOME_PATH = Etc.getpwuid.dir
    STATUS = {
      complete: 'Complete',
      error: 'Error'
    }

    attr_accessor :upload_bucket, :transcoded_bucket, :host

    def initialize(upload_bucket, transcoded_bucket, host)
      Aws.config.update({
        credentials: Aws::Credentials.new(ENV['AWS_S3_ACCESS_KEY_ID'], ENV['AWS_S3_SECRET_ACCESS_KEY']),
        region: 'ap-southeast-1'
      })

      @upload_bucket     =  upload_bucket
      @transcoded_bucket =  transcoded_bucket
      @host = host
    end

    def upload!(course_id, chapter_id, video_version)
      s3 = Aws::S3::Resource.new
      hash = Digest::SHA1.hexdigest("#{TRANSCODE_SALT}-#{course_id}-#{chapter_id}#{video_version}")

      files_in_folder = Dir.glob(HOME_PATH + "/video/#{course_id}/#{chapter_id}#{video_version}/#{hash}/*")
      files_in_folder.each do |filename|
        file = File.open(filename)
        s3.bucket(@transcoded_bucket).object("#{filename.gsub(HOME_PATH + "/", "")}").put(file, {body: file, acl: "public-read"} )
      end

      update_transcode_status!(chapter_id, STATUS[:complete])

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
      s3_obj = s3.bucket(@upload_bucket).object("#{path}").get(response_target: "#{download_path}#{chapter_id}#{video_version}.mp4")
    rescue Aws::S3::Errors::NoSuchKey
      update_transcode_status!(chapter_id, STATUS[:error])
    end

    def update_transcode_status!(chapter_id, status)
      uri           =  URI.parse(@host)
      https         =  Net::HTTP.new(uri.host, uri.port)
      https.use_ssl =  true
      https.send_request('PATCH', "/api/transcoder/chapters/#{chapter_id}/status/#{status}")
    end
  end
end
