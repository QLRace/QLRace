class ScoresController < ApplicationController
  before_filter :set_params

  def home
    @map_scores = WorldRecord.map_scores
  end

  def map
    @map = params[:map]
    @scores = Kaminari.paginate_array(Score.map_scores(params)).page(params[:page]).per(20)
  end

  def player
    @name, @average, @scores = Score.player_scores(params)
  end

  private

  def set_params
    @PARAMS = [{}, { weapons: 'false' }, { ruleset: 'vql', weapons: 'true' },
               { ruleset: 'vql', weapons: 'false' }]
  end
end
