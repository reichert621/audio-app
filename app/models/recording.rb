class Recording < ActiveRecord::Base
  validates :name, uniqueness: true
  mount_uploader :audio, AudioUploader
  belongs_to :excerpt
end
