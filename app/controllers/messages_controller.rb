class MessagesController < WebsocketRails::BaseController
  def message_receive
    receive_message = message()
    broadcast_message(:bingo_message, receive_message)
  end
end
