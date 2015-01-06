class Recording < ActiveRecord::Base
  validates :name, uniqueness: true
  mount_uploader :audio, AudioUploader
  belongs_to :excerpt
  belongs_to :user
  has_many :comments, as: :commentable
  has_many :favorites, as: :favoritable
end
