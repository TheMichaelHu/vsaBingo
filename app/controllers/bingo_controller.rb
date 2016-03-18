class BingoController < ApplicationController
  def play
     @room = Room.find(cookies[:room_id])
     @player = Player.find(cookies[:player_id])

  end
end
