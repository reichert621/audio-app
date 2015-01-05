class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :commentable_id, :commentable_type, :user_id, 
             :created_at, :updated_at, :author

  def author
    object.user.email
  end
end
