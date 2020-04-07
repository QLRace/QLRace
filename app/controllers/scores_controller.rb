# frozen_string_literal: true

class ScoresController < ApplicationController
  # CSRF is not needed since GET requests are idempotent
  skip_before_action :verify_authenticity_token
  caches_page :home

  def home
    @total_scores = Score.count
    @recent_wrs = WorldRecord.order(updated_at: :desc).includes(:player)
                             .limit(5)
    @map_scores = WorldRecord.map_scores
  end

  def map
    return unless Score.where(map: params[:map].downcase).exists?

    scores = Score.map_scores params
    total_scores = scores.length
    scores = Kaminari.paginate_array(scores).page(params[:page]).per(25)
    @map = { total_scores: total_scores, scores: scores }
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
    @recent = records.order(updated_at: :desc).includes(:player)
                     .page(params[:page]).per(25)
  end
end
