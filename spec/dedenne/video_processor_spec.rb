require 'spec_helper'

describe Dedenne::VideoProcessor do

  before(:each) do
    @course_id = "1"
    @chapter_id = "2"
    @video_version = "-1"
    @storage_service = Dedenne::StorageService.new(@course_id, @chapter_id, @video_version, 'skilllane')
    @storage_service.get_video_file
  end

  describe 'Video process method' do
    let(:video) { FFMPEG::Movie.new( Etc.getpwuid.dir + "/video/#{@course_id}/#{@chapter_id}#{@video_version}.mp4" ) }
    let(:index_file) { Etc.getpwuid.dir + "/video/#{@course_id}/#{@chapter_id}#{@video_version}/#{@storage_service.hash}/index.m3u8" }

    it 'should find a video file' do
      allow(FFMPEG::Movie).to receive(:new).and_return(video)
      Dedenne::VideoProcessor.new(@storage_service)
    end

    it 'should run generate keys script' do
      allow(FFMPEG::Movie).to receive(:new).and_return(video)
      video_processor = Dedenne::VideoProcessor.new(@storage_service)
      expect(video_processor).to receive(:system).with('./initkey.sh')
      video_processor.prepare_stuff
    end

    it 'should get transcoded video path' do
      video_processor = Dedenne::VideoProcessor.new(@storage_service)
      expect(video_processor.video_path)
        .to match(Etc.getpwuid.dir + "/video/#{@course_id}/#{@chapter_id}#{@video_version}/#{@storage_service.hash}")
    end

    it 'it should transcode fromm mp4 to hls' do
      video_processor = Dedenne::VideoProcessor.new(@storage_service)
      video_processor.prepare_stuff
      video_processor.mp4_to_hls
      expect(File.file?(index_file)).to be true
    end
  end
end
