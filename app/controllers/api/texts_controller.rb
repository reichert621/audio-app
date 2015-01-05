class Api::TextsController < ApplicationController
  def index
    texts = Text.all
    render json: texts, root: false
  end

  def show
    text = Text.find(params[:id])
    chapters = text.chapters
    render json: { text: text, chapters: chapters }, root: false
  end
end
