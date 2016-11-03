class PlayersController < ApplicationController
  autocomplete :player, :name
  # CSRF is not needed since GET requests are idempotent
  skip_before_action :verify_authenticity_token

  def index
    players = Player.search(params[:search]).order(:name)
    @total_players = players.count
    @players = players.page(params[:page]).per(25)
  end

  # Should maybe be in WorldRecordController?
  def most_wrs
    @mode = params.fetch(:mode, -1).to_i
    @mode = -1 unless @mode.between?(0, 3)
    @players = WorldRecord.most_world_records @mode
  end
end
