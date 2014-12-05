class CreateRecordings < ActiveRecord::Migration
  def change
    create_table :recordings do |t|
      t.string :name
      t.string :filename
      t.string :url

      t.timestamps
    end
  end
end
