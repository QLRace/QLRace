class Api::ScoresApiController < Api::ApiController
  resource_description do
    formats ['json']
    resource_id 'records'
  end

  def_param_group :mode do
    param :weapons, %w(true false), desc: 'Default is true'
    param :factory, %w(turbo classic), desc: 'Default is turbo'
  end

  api :GET, '/player/:id', 'Player records'
  param :id, Integer, desc: 'Player Steam ID', required: true
  param_group :mode
  def player
    name, average, medals, scores = Score.player_scores(params)
    render json: { name: name, average: average, medals: medals,
                   records: scores }
  end

  api :GET, '/map/:map', 'Map records'
  param :map, String, desc: 'Map name', required: true
  param_group :mode
  param :limit, Integer, desc: 'Number of records which will be returned'
  def map
    render json: { records: Score.map_scores(params) }
  end

  api :GET, '/maps', 'List of all maps'
  param :sort, %w(alphabetical recent), desc: 'Default is alphabetical'
  def maps
    maps = if params[:sort] == 'recent'
             Score.order(:created_at).pluck(:map).uniq.reverse
           else
             WorldRecord.order(:map).pluck(:map).uniq
           end
    render json: { maps: maps }
  end
end
