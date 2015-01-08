class SaveRecordingWorker
  include Sidekiq::Worker
  # sidekiq_options queue: "high"
  sidekiq_options retry: 3
  
  def perform(recording_id)
    recording = Recording.find(recording_id)
    recording.audio = File.open "#{Rails.root}/tmp/#{recording.name}"
    recording.save!
  end

end