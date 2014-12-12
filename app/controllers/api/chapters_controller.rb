class Api::ChaptersController < ApplicationController
  def index
    text = Text.find(params[:text_id])
    render json: text.chapters
  end
end
