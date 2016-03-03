class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :image_url
      t.integer :room
      t.timestamps
    end
  end
end
