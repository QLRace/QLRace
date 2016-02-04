class ScoresController < ApplicationController
  def home
    @total_scores = Score.count
    @recent_wrs = WorldRecord.order(updated_at: :desc).includes(:player)
                             .limit(5)
    @map_scores = WorldRecord.map_scores
  end

  def map
    name = params[:map]
    scores = Score.map_scores params
    total_scores = scores.length
    scores = Kaminari.paginate_array(scores).page(params[:page]).per(20)
    @map = { name: name, total_scores: total_scores, scores: scores }
  end

  def player
    name, average, medals, scores = Score.player_scores(params)
    @player = { name: name, average: average, medals: medals, scores: scores }
  end

  def recent
    get_recent_records Score
  end

  def recent_wrs
    @wrs = true
    get_recent_records WorldRecord
    render 'recent'
  end

  private def get_recent_records(model)
    mode = params.fetch(:mode, -1).to_i
    records = mode.between?(0, 3) ? model.where(mode: mode) : model
    @recent = records.order(updated_at: :desc).includes(:player)
              .page(params[:page]).per(20)
  end
end
