class RoomsController < ApplicationController
  def new
  end

  def create
    @room = Room.new(name: params[:name])
    room_code = (0...5).map do ('A'..'Z').to_a[rand(26)] end.join
    @room.code = room_code
    if @room.save
      redirect_to controller: :lobby, action: :join, code: @room.code
    else
      render :new
    end
  end

  def show
    @room = Room.find(:id)
    if @room.nil?
      raise ActionController::RoutingError.new('Room Not Found')
    end
  end

end
