class LobbyController < ApplicationController
  def join
    @room = Room.where('upper(code) = ?', params[:code].upcase).first
    if @room.nil?
      raise ActionController::RoutingError.new('Room Not Found')
    end
  end
end
