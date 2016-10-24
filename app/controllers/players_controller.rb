class PlayersController < ApplicationController
  autocomplete :player, :name

  def index
    players = Player.search(params[:search]).order(:name)
    @total_players = players.count
    @players = players.page(params[:page]).per(25)
  end

  # Should maybe be in WorldRecordController?
  def most_wrs
    @mode = params.fetch(:mode, -1).to_i
    @players = WorldRecord.most_world_records @mode
  end
end
