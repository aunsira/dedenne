require 'spec_helper'
require 'streamio-ffmpeg'
require 'dedenne/ffmpeg'
require 'fileutils'


describe Dedenne::FFMPEGHLS do
  describe 'initialize' do
    course_id = "1"
    chapter_id = "2"
    video_version = "-1"
    let(:video) { FFMPEG::Movie.new("/Users/aun/video/#{course_id}/#{chapter_id}#{video_version}.mp4") }

    it 'Should find a video file' do
      allow(FFMPEG::Movie).to receive(:new).and_return(video)
      Dedenne::FFMPEGHLS.new(course_id, chapter_id, video_version)
    end
  end
end
