class PlayersController < ApplicationController
  def create
    @player = Player.new(player_params)
    if @player.save
      redirect_to controller: :rooms, action: :show, id: @player.room_id, player: @player.id
    else
      redirect_to controller: :lobby, action: :join, code: Room.find(params[:room_id]).code
    end
  end

  private

    def player_params  
      params.require(:players).permit(:name, :room_id)
    end
end
