require 'spec_helper'

describe Dedenne::RequestHandler do
  before(:each) do
    @course_id = '1'
    @chapter_id = '2'
    @video_version = '-1'
    @service = Dedenne::StorageService.new(@course_id, @chapter_id, @video_version, 'skilllane')
  end

  describe 'update transcode status' do
    it 'should be able to update transcode status' do
      request = Dedenne::RequestHandler.new(2, @service.host)
      request.update_transcode_status(@service.config.transcode_status[:complete])
    end

    it 'should be able to update chapter duration' do
      request = Dedenne::RequestHandler.new(2, @service.host)
      request.update_video_duration('200')
    end
  end
end
