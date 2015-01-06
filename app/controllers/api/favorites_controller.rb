class Api::FavoritesController < ApplicationController
  def create
    unless user_signed_in? 
      render json: { message: "Please sign in" }, status: 422
      return
    end

    favoritable = find_favoritable
    if favoritable
      favorite = favoritable.favorites.new(favorite_params)
      favorite.user_id = current_user.id
    end

    if favorite.save
      render json: favorite, root: false
    else
      render json: favorite.errors.full_messages
    end
  end

  def destroy
    unless user_signed_in? 
      render json: { message: "Please sign in" }, status: 422
      return
    end

    favorite = Favorite.find(params[:id])
    favorite.destroy!
    render json: favorite, root: false
  end

  private
  def favorite_params
    params.require(:favorite).permit(:favoritable_id, :favoritable_type)
  end

  def find_favoritable
    type, id = favorite_params[:favoritable_type], favorite_params[:favoritable_id]
    if type && id
      type.classify.constantize.find(id)
    else
      nil
    end
  end
end
