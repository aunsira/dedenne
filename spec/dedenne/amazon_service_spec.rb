require 'spec_helper'

describe Dedenne::AmazonService do

  before(:each) do
    @aws = Dedenne::AmazonService.new
    @storage_service = Dedenne::StorageService.new('1', '2', '-1', 'skilllane')
  end

  describe 'Amazon service' do
    it 'should get S3 resource' do
      expect(@aws.connect_s3).to be_a Aws::S3::Resource
    end

    it 'should get S3 object' do
      expect(@aws.s3_object(@storage_service.transcoded_bucket, @storage_service.transcoded_video_path)).to be_a Aws::S3::Object
    end
  end
end
