# frozen_string_literal: true

class ScoresController < ApplicationController
  include Pagy::Backend

  # CSRF is not needed since GET requests are idempotent
  skip_before_action :verify_authenticity_token
  caches_page :home

  def home
    @total_scores = Score.count

    qlwc = Qlwc.new
    @recent_wrs = WorldRecord.where.not(map: qlwc.hidden_maps(Time.now.utc))
                             .order(updated_at: :desc).includes(:player)
                             .limit(5)
    @map_scores = WorldRecord.map_scores
  end

  def map
    return unless Score.exists?(map: params[:map].downcase)

    qlwc = Qlwc.new
    hidden_maps = qlwc.hidden_maps(Time.now.utc)
    return if hidden_maps.include?(params[:map].downcase)

    @map = Score.map_scores_paginated params
    @pagy = Pagy.new(count: @map[:total_records], page: params[:page])
  end

  def player
    @player = Score.player_scores(params)
  end

  def recent
    get_recent_records Score
  end

  def recent_wrs
    @wrs = true
    get_recent_records WorldRecord
    render 'recent'
  end

  private

  def get_recent_records(model)
    mode = params.fetch(:mode, -1).to_i
    records = mode.between?(0, 3) ? model.where(mode: mode) : model

    qlwc = Qlwc.new
    @pagy, @recent = pagy(records.where.not(map: qlwc.hidden_maps(Time.now.utc))
                                 .order(updated_at: :desc)
                                 .includes(:player))
  end
end
