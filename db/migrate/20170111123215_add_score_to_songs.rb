class AddScoreToSongs < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :score, :integer
  end
end
