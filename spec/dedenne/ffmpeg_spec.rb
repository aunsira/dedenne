require 'spec_helper'
require 'dedenne/ffmpeg'


describe Dedenne::FFMPEGHLS do
  describe 'initialize ffmpeg' do
    it 'testing' do
      course_id = 1
      chapter_id = 2
      video_version = 1
      foo = Dedenne::FFMPEGHLS.new(course_id, chapter_id, video_version)
      expect(foo).to eq nil
    end
  end
end
