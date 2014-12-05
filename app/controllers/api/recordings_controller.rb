class Api::RecordingsController < ApplicationController
  def index
    recordings = Recording.all
    render json: recordings
  end

  def create
    recording = Recording.new(recording_params)
    if recording.save
      render json: recording
    else
      render json: recording.errors.full_messages, status: 422
    end
  end

  def show
  end

  private
  def recording_params
    params.require(:recording).permit(:name, :url, :filename)
  end
end
