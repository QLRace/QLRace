class Score < ActiveRecord::Base
  belongs_to :player
  validates :map, :mode, :player_id, :time, :match_guid, presence: true
  validates_inclusion_of :mode, in: 0..3
  validates :player, presence: true
  validates :player_id, uniqueness: { scope: [:map, :mode],
                                      message: 'Players may only have one record per map for each mode.' }

  def self.new_score(map, mode, player_id, time, match_guid, name)
    player = Player.where(id: player_id).first_or_initialize
    player.name = name
    player.save

    score = Score.where(map: map, mode: mode, player_id: player_id).first_or_initialize
    if score.time.nil? || time < score.time
      score.time = time
      score.match_guid = match_guid
      score.save
      WorldRecord.check(map, mode, player_id, time, match_guid)
      return true
    else
      return false
    end
  end

  def self.player_scores(params)
    mode = mode_from_params(params)
    scores = []
    begin
      player_id = Integer(params[:player_id])
      p = Player.find(player_id)
    rescue ArgumentError, ActiveRecord::RecordNotFound
      # player id is not an int or doesn't exist
      # return name and avg as nil and empty scores array
      return nil, nil, nil, []
    end
    medals = [0, 0, 0]
    p.scores.where(mode: mode).order(:map).each do |score|
      rank = Score.where(map: score.map, mode: mode).where('time < ?', score.time).count + 1
      scores << { map: score.map, mode: mode, rank: rank, time: score.time, match_guid: score.match_guid,
                  date: score.updated_at }
      if rank.between?(1, 3)
        medals[rank - 1] += 1
      end
    end
    avg = scores.map { |s| s[:rank] }.reduce(0, :+) / scores.size.to_f
    [p.name, avg.round(2), medals, scores]
  end

  def self.map_scores(params)
    mode = mode_from_params(params)
    scores = []
    limit = Integer(params.fetch(:limit, 0))
    last_time = -1
    last_rank = 1
    Score.where(map: params[:map], mode: mode).order(:time, :updated_at).includes(:player).each.with_index(1) do |score, r|
      if last_time == score.time
        rank = last_rank
      else
        rank = r
      end

      scores << { mode: mode, rank: rank, player_id: score.player_id, name: score.player.name,
                  time: score.time, match_guid: score.match_guid, date: score.updated_at }
      last_rank = rank
      last_time = score.time
      break if r >= limit && limit != 0
    end
    scores
  end

  private

  def self.mode_from_params(params)
    factory = params.fetch(:factory, 'turbo')
    w = params.fetch(:weapons, 'true')
    if params[:weapons].nil?
      weapons = true
    else
      weapons = ActiveRecord::Type::Boolean.new.type_cast_from_user(w)
    end
    if factory == 'classic'
      return weapons ? 2 : 3
    else
      return weapons ? 0 : 1
    end
  end
end
