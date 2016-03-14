class MessagesController < WebsocketRails::BaseController
  def message_receive
    receive_message = message()
    broadcast_message(:bingo_message, receive_message)
  end

  def initialize_session
    controller_store = {}
  end

  def message_receive
    receive_message = message()
    puts "Recieved #{receive_message} DJFKJSDLFJLKSDJFLKJSDLKFJ"
    broadcast_message(:bingo_message, receive_message)
  end

  def handle_room_message
    puts "#{controller_store}"
    msg = message()
    room = msg["room"]
    player = msg["player"]
    if msg["type"] == "join"
      controller_store[room] ||= Set.new
      controller_store[room].add player
      send_update room
    elsif msg["type"] == "leave"
      controller_store[room].delete player
      send_update room
    elsif msg["type"] == "start"
      puts "YESSSS"
      broadcast_message room.to_s, {type: "start"}
    end
  end

  def send_update(room)
    broadcast_message room.to_s, {type: "update", data: controller_store[room].length}
  end
end
