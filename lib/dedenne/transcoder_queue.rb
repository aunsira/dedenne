class TranscoderQueue
  @queue = :transcode

  def self.perform(course_id, chapter_id, video_version)
    Dedenne::transcode(course_id, chapter_id, video_version)
    puts "Done!"
  end
end
