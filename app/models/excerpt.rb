class Excerpt < ActiveRecord::Base
  validates :rank, :content, presence: true
  belongs_to :text
  has_many :recordings
end
