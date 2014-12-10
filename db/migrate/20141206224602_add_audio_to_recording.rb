class AddAudioToRecording < ActiveRecord::Migration
  def change
    add_column :recordings, :audio, :string
  end
end
