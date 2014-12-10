class Api::RecordingsController < ApplicationController
  require 'base64'
  def index
    recordings = Recording.all
    render json: recordings
  end

  def create
    recording = Recording.new(recording_params)
    recording.audio = decoded_audio_file

    if recording.save
      render json: recording
    else
      render json: recording.errors.full_messages, status: 422
    end
  end

  def show
  end

  private

  def decoded_audio_file
    decoded_audio = Base64.decode64(recording_params[:audio].split(",").last)
    file = File.open("#{Rails.root}/tmp/#{recording_params[:name]}", "wb:binary") do |f|
      f.write(decoded_audio)
    end
    File.open "#{Rails.root}/tmp/#{recording_params[:name]}"
  end

  def recording_params
    params.require(:recording).permit(:name, :url, :filename, :audio)
  end
end
