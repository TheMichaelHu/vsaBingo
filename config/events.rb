WebsocketRails::EventMap.describe do
  subscribe :messages, to: MessagesController, with_method: :message_receive
end