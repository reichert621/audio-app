class Api::TextsController < ApplicationController
  def index
    texts = Text.all
    render json: texts
  end

  def show
    text = Text.find(params[:id])
    chapters = text.chapters
    render json: { text: text, chapters: chapters }
  end
end
