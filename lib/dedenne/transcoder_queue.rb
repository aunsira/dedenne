class TranscoderQueue
  @queue = :transcode

  def self.perform(course_id, chapter_id, video_version, upload_bucket, transcoded_bucket, host)
    Dedenne::transcode(course_id, chapter_id, video_version, upload_bucket, transcoded_bucket, host)
    puts "Done!"
  end
end
