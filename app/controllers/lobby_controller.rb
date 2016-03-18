class LobbyController < ApplicationController
  def join
    @room = Room.where('upper(code) = ?', params[:code].upcase).first
    cookies[:room_id] = @room.id
    if @room.nil?
      raise ActionController::RoutingError.new('Room Not Found')
    end
  end
end
