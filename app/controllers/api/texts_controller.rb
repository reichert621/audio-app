class Api::TextsController < ApplicationController
  def index
    texts = Text.all
    render json: texts
  end

  def show
    text = Text.find(params[:id])
    render json: text
  end
end
