WebsocketRails::EventMap.describe do
  subscribe :bingo_message, to: MessagesController, with_method: :message_receive
<<<<<<< HEAD
=======
  subscribe :room_message, to: MessagesController, with_method: :handle_room_message
>>>>>>> 6f9192d8ae9ec399de55d5ef183f8a6597d29131
end
