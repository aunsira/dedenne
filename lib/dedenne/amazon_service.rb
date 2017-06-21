require 'aws-sdk'

module Dedenne
  class AmazonService
    attr_reader :key_id, :secret_key

    def initialize
      @key_id     = ENV['AWS_S3_ACCESS_KEY_ID']
      @secret_key = ENV['AWS_S3_SECRET_ACCESS_KEY']
      setup_config
    end

    def connect_s3
      Aws::S3::Resource.new
    end

    def s3_object(bucket, object)
      Aws::S3::Object.new(bucket, object, client: s3_client)
    end

    private

      def setup_config
        Aws.config.update(credentials: Aws::Credentials.new(key_id, secret_key),
                          region: 'ap-southeast-1')
      end

      def s3_client
        Aws::S3::Client.new(region: 'ap-southeast-1')
      end
  end
end
