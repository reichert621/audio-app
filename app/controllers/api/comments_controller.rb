class Api::CommentsController < ApplicationController
  def index
  end

  def create
    unless user_signed_in? 
      render json: { message: "Please sign in" }, status: 422
      return
    end

    commentable = find_commentable
    if commentable
      comment = commentable.comments.new(comment_params)
      comment.user_id = current_user.id
    end

    if comment.save
      render json: comment, root: false
    else
      render json: comment.errors.full_messages
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :commentable_id, :commentable_type)
  end

  def find_commentable
    type, id = comment_params[:commentable_type], comment_params[:commentable_id]
    if type && id
      type.classify.constantize.find(id)
    else
      nil
    end
  end
end
