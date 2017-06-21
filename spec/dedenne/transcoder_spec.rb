require 'spec_helper'

describe Dedenne::Transcoder do
  describe 'Transcoder' do
    it 'should be able to call transcode' do
      transcoder = Dedenne::Transcoder.new('1', '2', '-1', 'skilllane')
      transcoder.transcode
    end
  end
end
