class PlayersController < ApplicationController
  def create
    @player = Player.new(player_params)
    if @player.save
      cookies[:player_id] = @player.id
      redirect_to controller: :rooms, action: :show, id: @player.room_id
    else
      redirect_to controller: :lobby, action: :index
    end
  end

  private

    def player_params  
      params.require(:players).permit(:name, :room_id)
    end
end
