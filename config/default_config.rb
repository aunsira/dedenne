class DefaultConfig

  def initialize; end

  def skilllane
    "skilllane"
  end

  def schoollane
    "schollane"
  end

  def skilllane_origin_bucket
    ENV['RACK_ENV'] == 'test' ? "classroomapp" : "skilllane"
  end

  def skilllane_transcoded_bucket
    ENV['RACK_ENV'] == 'test' ? "classroomapp-transcoded" : "skilllane-video"
  end

  def schoollane_origin_bucket
    "schoollane"
  end

  def schoollane_transcoded_bucket
    "schoollane-video"
  end

  def skilllane_host
    ENV['RACK_ENV'] == 'test' ? "https://www.sklclassroomapp.com" : "https://www.skilllane.com"
  end

  def schoollane_host
    "https://www.schoollane.com"
  end

  def transcode_salt
    'foobar'
  end

  def transcode_status
    {
      complete: "Complete",
      error: "Error"
    }
  end

  def bitrates
    {
      480  => "900",
      720  => "1800",
      1080 => "3000"
    }
  end

  def redis_url
    if ENV['REDIS_PORT_6379_TCP_ADDR'] && ENV['REDIS_PORT_6379_TCP_PORT']
      "redis://:#{ENV['REDIS_PASSWORD']}@#{ENV['REDIS_PORT_6379_TCP_ADDR']}:#{ENV['REDIS_PORT_6379_TCP_PORT']}"
    else
      "redis://localhost:6379"
    end
  end
end
