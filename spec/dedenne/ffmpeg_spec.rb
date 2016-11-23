require 'spec_helper'
require 'streamio-ffmpeg'
require 'dedenne/ffmpeg'
require 'fileutils'


describe Dedenne::FFMPEGHLS do
  describe 'initialize' do
    it 'Should find a video file' do
      course_id = "1"
      chapter_id = "2"
      video_version = "-1"
      allow(FFMPEG::Movie).to receive(:new).and_return("/Users/aun/video/#{course_id}/#{chapter_id}#{video_version}.mp4")
      Dedenne::FFMPEGHLS.new(course_id, chapter_id, video_version)
    end
  end
end
