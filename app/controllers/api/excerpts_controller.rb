class Api::ExcerptsController < ApplicationController
  def index
    chapter = Chapter.find(params[:chapter_id])
    render json: chapter.excerpts.includes(:favorites), root: false
  end

  def show
    excerpt = Excerpt.find(params[:id])
    render json: excerpt, serializer: ExcerptSerializer, root: false
  end
end