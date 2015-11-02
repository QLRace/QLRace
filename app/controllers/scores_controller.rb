class ScoresController < ApplicationController
  def home
    @wrs = WorldRecord.order(updated_at: :desc).includes(:player).limit(5)
    @map_scores = WorldRecord.map_scores
  end

  def map
    @map = params[:map]
    scores = Score.map_scores(params)
    @length = scores.length
    @scores = Kaminari.paginate_array(scores).page(params[:page]).per(20)
  end

  def player
    @name, @average, @scores = Score.player_scores(params)
  end

  def recent_wrs
    @wrs = WorldRecord.order(updated_at: :desc).includes(:player).page(params[:page]).per(20)
  end
end
