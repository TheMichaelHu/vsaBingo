# -*- coding: utf-8 -*-
class MessagesController < WebsocketRails::BaseController
  def message_receive
    receive_message = message()
    broadcast_message(:messages, receive_message)
  end
end
