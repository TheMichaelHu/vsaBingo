class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :code
      t.boolean :started
      t.timestamps null: false
    end
  end
end
