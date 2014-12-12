class CreateExcerpts < ActiveRecord::Migration
  def change
    create_table :excerpts do |t|
      t.integer :text_id
      t.integer :chapter_id
      t.integer :rank
      t.text :content

      t.timestamps
    end
  end
end
