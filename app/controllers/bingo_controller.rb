class BingoController < ApplicationController
  def play
     @room = Room.where('upper(code) = ?', cookies[:room_code].upcase).first
     @player = Player.find(cookies[:player_id])

  end
end
