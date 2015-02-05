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
    recording = excerpt.recordings.new(name: params[:name])
    recording.user_id = current_user.id

    if params[:file]
      recording.audio = params[:file]
    elsif params[:audio]
      recording.url = params[:url]
      split_file = params[:audio].scan(/.{1,100000}/)
      MEMCACHED.with do |conn|
        conn.set("#{params[:name]}_count", split_file.count)
        split_file.each_with_index do |str, idx|
          conn.set("#{params[:name]}_#{idx}", str)
        end
      end
    end

    if recording.save
      SaveRecordingWorker.perform_async(recording.id) if params[:audio]
      render json: recording, root: false
    else
      render json: recording.errors.full_messages, root: false, status: 422
    end
  end

  def destroy
    recording = Recording.find(params[:id])
    recording.destroy!
    render json: recording, root: false
  end

  private

  def recording_params
    params.require(:recording).permit(:name, :url, :filename, :audio, :file)
  end
end
