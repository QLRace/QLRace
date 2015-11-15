class PlayersController < ApplicationController
  autocomplete :player, :name

  def index
    if params[:search]
      players = Player.search(params[:search]).order(:name)
    else
      players = Player.order(:name)
    end
    @total_players = players.count
    @players = players.page(params[:page]).per(20)
  end
end
