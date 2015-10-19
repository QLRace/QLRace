class PlayersController < ApplicationController
  autocomplete :player, :name

  def index
    if params[:search]
      @players = Player.search(params[:search]).order(:name).page(params[:page]).per(20)
    else
      @players = Player.order(:name).page(params[:page]).per(20)
  end
  end
end
