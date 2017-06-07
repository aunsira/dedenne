require 'spec_helper'

describe Dedenne::StorageService do

  before(:each) do
    @course_id = "1"
    @chapter_id = "2"
    @video_version = "-1"
    @service = Dedenne::StorageService.new(@course_id, @chapter_id, @video_version, 'SkillLane')
  end

  describe 'Storage service' do
    it 'should get original video path' do
      expect(@service).to receive(:get_video_file)
      @service.get_video_file
    end

    it 'should upload transcoded video file' do
      expect(@service).to receive(:upload)
      @service.upload
    end

    it 'should return original video path' do
      expect(@service.original_video_path).to match('video/1/2-1.mp4')
    end

    it 'should return transcode video path' do
      expect(@service.transcoded_video_path).to match("video/1/2-1/36155ffb5f8a6e48dd040c384ccf28d24e0746c4/index.m3u8")
    end

    it 'should find correctly that video chapter is arleady transcoded' do
      expect(@service.already_transcoded?).to eql(true)
    end
  end
end
