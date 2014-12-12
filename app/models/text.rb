class Text < ActiveRecord::Base
  validates :name, presence: true
  has_many :chapters
  has_many :excerpts
end
