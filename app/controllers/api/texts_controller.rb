class Api::TextsController < ApplicationController
  def index
    texts = Text.all
    render json: texts, root: false
  end

  def create
    binding.pry
    render json: {}
  end

  def show
    text = Text.find(params[:id])
    chapters = text.chapters
    render json: { text: text, chapters: chapters }, root: false
  end

  def update
    text = Text.find(params[:id])
    text.image = params[:file]
    if text.save!
      render json: text, root: false
    else
      render json: text.errors.full_messages, status: 422
    end
  end
end
