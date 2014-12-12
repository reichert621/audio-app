class Chapter < ActiveRecord::Base
  belongs_to :text
  has_many :excerpts
end
