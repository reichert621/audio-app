class Api::ChaptersController < ApplicationController
  def index
    text = Text.find(params[:text_id])
    render json: text.chapters, root: false
  end

  def show
    chapter = Chapter.find(params[:id])
    render json: chapter, root: false
  end
end
