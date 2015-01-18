class Text < ActiveRecord::Base
  validates :name, presence: true
  mount_uploader :image, ImageUploader
  has_many :favorites, as: :favoritable
  has_many :chapters
  has_many :excerpts
end
