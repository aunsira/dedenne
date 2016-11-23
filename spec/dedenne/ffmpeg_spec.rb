require 'spec_helper'
require 'streamio-ffmpeg'
require 'dedenne/ffmpeg'
require 'fileutils'


describe Dedenne::FFMPEGHLS do
  course_id = "1"
  chapter_id = "2"
  video_version = "-1"

  describe 'initialize' do
    let(:video) { FFMPEG::Movie.new("/Users/aun/video/#{course_id}/#{chapter_id}#{video_version}.mp4") }

    it 'Should find a video file' do
      allow(FFMPEG::Movie).to receive(:new).and_return(video)
      Dedenne::FFMPEGHLS.new(course_id, chapter_id, video_version)
    end

    it 'should run generate keys script' do
      allow(FFMPEG::Movie).to receive(:new).and_return(video)
      ffmpeg = Dedenne::FFMPEGHLS.new(course_id, chapter_id, video_version)
      expect(ffmpeg).to receive(:system).with('./initkey.sh')
      ffmpeg.generate_key_files
    end
  end

  describe 'hashing' do
    it 'should hash correctly' do
      ffmpeg = Dedenne::FFMPEGHLS.new(course_id, chapter_id, video_version)
      hash_code = ffmpeg.hash
      expect(hash_code).to eq("36155ffb5f8a6e48dd040c384ccf28d24e0746c4")
    end
  end
end
