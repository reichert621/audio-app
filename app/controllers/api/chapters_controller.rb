class Api::ChaptersController < ApplicationController
  def index
    text = Text.find(params[:text_id])
    render json: text.chapters
  end

  def show
    chapter = Chapter.find(params[:id])
    render json: chapter
  end
end
