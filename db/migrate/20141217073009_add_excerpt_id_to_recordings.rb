class AddExcerptIdToRecordings < ActiveRecord::Migration
  def change
    add_column :recordings, :excerpt_id, :integer
  end
end
