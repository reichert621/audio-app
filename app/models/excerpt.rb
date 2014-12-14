class Excerpt < ActiveRecord::Base
  validates :rank, :content, presence: true
  belongs_to :text
  belongs_to :chapter
  has_many :recordings
end
