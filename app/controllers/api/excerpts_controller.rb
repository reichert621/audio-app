class Api::ExcerptsController < ApplicationController
  def index
    chapter = Chapter.find(params[:chapter_id])
    render json: chapter.excerpts, root: false
  end

  def show
    excerpt = Excerpt.find(params[:id])
    chapter = excerpt.chapter
    render json: { excerpt: excerpt, chapter: chapter }, root: false
  end
end