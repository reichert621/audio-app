class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :name
      t.integer :text_id
      t.integer :rank

      t.timestamps
    end
  end
end
