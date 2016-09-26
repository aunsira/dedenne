require 'aws-sdk'

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
  end
end
