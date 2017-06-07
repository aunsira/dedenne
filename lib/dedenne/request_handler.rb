require 'net/http'

module Dedenne
  class RequestHandler
    def initialize(chapter_id, host)
      @chapter_id = chapter_id
      @host       = host
      @request    = setup_connection
    end

    def update_transcode_status(status)
      @request.send_request('PATCH', "/api/transcoder/chapters/#{chapter_id}/status/#{status}")
    end

    def update_video_duration(duration)
      @request.send_request('PATCH', "/api/transcoder/chapters/#{chapter_id}/video_duration/#{duration}")
    end

    private

      attr_reader :chapter_id, :host, :request

      def setup_connection
        uri           = URI.parse(host)
        https         = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        https
      end
  end
end
