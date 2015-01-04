class Api::RecordingsController < ApplicationController
  require 'base64'
  def index
    excerpt = Excerpt.find(params[:excerpt_id])
    render json: excerpt.recordings.to_json(include: { user: { only: :email } })
  end

  def create
    excerpt = Excerpt.find(params[:excerpt_id])
    recording = excerpt.recordings.new(recording_params)
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
