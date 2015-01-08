class Api::RecordingsController < ApplicationController
  require 'base64'
  def index
    excerpt = Excerpt.find(params[:excerpt_id])
    recordings = excerpt.recordings.includes(:user, :comments)
    render json: recordings, each_serializer: RecordingSerializer, root: false
  end

  def create
    unless user_signed_in? 
      render json: { message: "Please sign in" }, status: 422
      return
    end

    excerpt = Excerpt.find(params[:excerpt_id])
    recording = excerpt.recordings.new(recording_params)
    recording.user_id = current_user.id

    if recording.save
      decoded_audio = Base64.decode64(recording_params[:audio].split(",").last)
      file = File.open("#{Rails.root}/tmp/#{recording.name}", "wb:binary") do |f|
        f.write(decoded_audio)
      end
      SaveRecordingWorker.perform_async(recording.id)
      render json: recording, root: false
    else
      render json: recording.errors.full_messages, status: 422
    end
  end

  private

  def recording_params
    params.require(:recording).permit(:name, :url, :filename, :audio)
  end
end
