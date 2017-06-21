require 'spec_helper'

describe Dedenne::TranscoderQueue do
  describe 'Transcoder Queue' do
    it 'does perform' do
      Dedenne::TranscoderQueue.perform('1', '2', '-1', nil)
    end

    it 'has version' do
      expect(Dedenne::VERSION).not_to be_nil
    end
  end
end
