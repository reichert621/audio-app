class Recording < ActiveRecord::Base
  validates :name, :url, uniqueness: true
end
