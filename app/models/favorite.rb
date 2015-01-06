class Favorite < ActiveRecord::Base
  belongs_to :favoritable, polymorphic: true
  belongs_to :user

  validates_uniqueness_of :user_id, :scope => :favoritable_id
end
