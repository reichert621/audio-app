class Api::ExcerptsController < ApplicationController
  def index
    chapter = Chapter.find(params[:chapter_id])
    render json: chapter.excerpts
  end
end
