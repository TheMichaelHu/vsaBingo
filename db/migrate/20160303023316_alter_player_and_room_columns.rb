class AlterPlayerAndRoomColumns < ActiveRecord::Migration
  def up
    change_column "rooms", "name", :string, limit: 20, nil: false
    change_column "rooms", "started", :boolean, default: false

    change_column "players", "name", :string, limit: 20, nil: false
    rename_column "players", "room", "room_id"
    change_column "players", "room_id", :integer, nil: false
    add_index("players", "room_id")
  end

  def down
    remove_index("players", "room_id")
    rename_column "players", "room_id", "room"
    change_column "players", "room", :integer, nil: true
    change_column "players", "name", :string, nil: true

    change_column "rooms", "started", :boolean, default: nil
    change_column "rooms", "name", :string, nil: true
  end
end
