class SaveRecordingWorker
  require 'base64'
  include Sidekiq::Worker
  # sidekiq_options queue: "high"
  sidekiq_options retry: 3
  
  def perform(recording_id, audio_file)
    recording = Recording.find(recording_id)
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