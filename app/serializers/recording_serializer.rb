class RecordingSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :audio_url, :author, :url
  has_many :comments

  def audio_url
    object.audio.url
  end

  def author
    object.user.email
  end
end
