WebsocketRails::EventMap.describe do
  subscribe :bingo_message, to: MessagesController, with_method: :message_receive
  subscribe :room_message, to: MessagesController, with_method: :handle_room_message
  subscribe :bingo_message, to: MessagesController, with_method: :handle_bingo_message
end
