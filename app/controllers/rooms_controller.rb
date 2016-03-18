class RoomsController < ApplicationController
  @@players ||= Set.new

  def new
  end

  def create
    @room = Room.new(room_params)
    room_code = (0...5).map do ('A'..'Z').to_a[rand(26)] end.join
    @room.code = room_code
    if @room.save
      @player = Player.create(name: params[:players][:name], room_id: @room.id)
      cookies[:player_id] = @player.id
      cookies[:room_id] = @room.id
      redirect_to controller: :rooms, action: :show, id: @room.id
    else
      render :new
    end
  end

  def show
    @players = @@players
    @room = Room.find(params[:id])
    @player = Player.find(cookies[:player_id])
    if @room.nil?
      raise ActionController::RoutingError.new('Room Not Found')
    elsif @player.nil? or @player.room_id != @room.id
      raise ActionController::RoutingError.new("You are not welcome here")
    end
    @@players.add @player.id
  end

  private

    def room_params
      params.require(:rooms).permit(:name)
    end

end
