WebsocketRails::EventMap.describe do
  subscribe :bingo_message, to: MessagesController, with_method: :message_receive
end
