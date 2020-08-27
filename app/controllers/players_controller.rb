# frozen_string_literal: true

class PlayersController < ApplicationController
  include Pagy::Backend

  autocomplete :player, :name
  # CSRF is not needed since GET requests are idempotent
  skip_before_action :verify_authenticity_token

  def index
    @pagy, @players = pagy(Player.search(params[:search]).order(:name))
  end

  # Should maybe be in WorldRecordController?
  def most_wrs
    @mode = params.fetch(:mode, -1).to_i
    @mode = -1 unless @mode.between?(0, 3)
    @players = WorldRecord.most_world_records @mode
  end
end
