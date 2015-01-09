class Api::RecordingsController < ApplicationController

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

    split_file = recording_params[:audio].scan(/.{1,100000}/)
    MEMCACHED.with do |conn|
      conn.set("#{recording_params[:name]}_count", split_file.count)
      split_file.each_with_index do |str, idx|
        conn.set("#{recording_params[:name]}_#{idx}", str)
      end
    end

    if recording.save
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
