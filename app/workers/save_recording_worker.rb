class SaveRecordingWorker
  require 'base64'
  include Sidekiq::Worker
  # sidekiq_options queue: "high"
  sidekiq_options retry: 3
  
  def perform(recording_id)
    recording = Recording.find(recording_id)
    arr = []
    MEMCACHED.with do |conn|
      count = conn.get("#{recording.name}_count")
      count.times do |i|
        arr << conn.get("#{recording.name}_#{i}")
      end
    end
    audio_file = arr.join
    decoded_audio = Base64.decode64(audio_file.split(",").last)
    file = File.open("#{Rails.root}/tmp/#{recording.name}", "wb:binary") do |f|
      f.write(decoded_audio)
    end

    recording.audio = File.open "#{Rails.root}/tmp/#{recording.name}"

    begin
      recording.save!
    rescue => e
      raise e
    end
  end

end