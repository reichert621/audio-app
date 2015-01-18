class AddImageToText < ActiveRecord::Migration
  def change
    add_column :texts, :image, :string
  end
end
