# frozen_string_literal: true
class PlayersController < ApplicationController
  autocomplete :player, :name

  def index
    players = Player.search(params[:search]).order(:name)
    @total_players = players.count
    @players = players.page(params[:page]).per(25)
  end
end
