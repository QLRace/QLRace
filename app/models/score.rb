# frozen_string_literal: true
# == Schema Information
#
# Table name: scores
#
#  id         :integer          not null, primary key
#  map        :string           not null
#  mode       :integer          not null
#  player_id  :bigint           not null
#  time       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  match_guid :uuid             not null
#  api_id     :integer
#

class Score < ActiveRecord::Base
  belongs_to :player
  validates :map, :mode, :player_id, :time, :match_guid, :player, presence: true
  validates :mode, inclusion: { in: 0..3 }
  validates :time, numericality: { only_integer: true,
                                   greater_than: 0 }
  validates :player_id, uniqueness: { scope: [:map, :mode],
                                      message: 'Players may only have one record
                                                per map for each mode.' }

  def rank_
    Score.where(map: map, mode: mode).where('time < ?', time).count + 1
  end

  def self.new_score(score)
    Player.update_player_name(score[:player_id], score[:name])

    s = player_score(score[:map], score[:mode], score[:player_id])
    return false unless s.time.nil? || score[:time] < s.time

    update_score(s, score)
    WorldRecord.check(score)
    true
  end

  def self.player_scores(params)
    mode = mode_from_params(params)
    scores = []
    begin
      player_id = Integer(params[:player_id])
      p = Player.find(player_id)
    rescue ArgumentError, ActiveRecord::RecordNotFound
      # player id is not an int or doesn't exist
      # return name and avg as nil, medals and scores as empty arrays
      return nil, nil, [], []
    end
    medals = [0, 0, 0]
    p.scores.where(mode: mode).order(:map).each do |score|
      rank = score.rank_
      scores << { map: score.map, mode: mode, rank: rank, time: score.time,
                  match_guid: score.match_guid, id: score.id,
                  date: score.updated_at }
      medals[rank - 1] += 1 if rank.between?(1, 3)
    end
    avg = scores.map { |s| s[:rank] }.reduce(0, :+) / scores.size.to_f
    [p.name, avg.round(2), medals, scores]
  end

  def self.map_scores(params)
    mode = mode_from_params params
    map = params[:map]
    query = <<-SQL
    SELECT rank() OVER (ORDER BY time), scores.id, mode, player_id, name, time,
           match_guid, scores.updated_at as date
    FROM scores
    INNER JOIN players
    ON scores.player_id = players.id
    WHERE mode = ? AND map = ?
    ORDER BY rank, date
    SQL
    Score.find_by_sql [query, mode, map]
  end

  def self.player_score(map, mode, player_id)
    Score.find_or_initialize_by(map: map, mode: mode, player_id: player_id)
  end

  def self.update_score(score, new_score)
    score.time = new_score[:time]
    score.match_guid = new_score[:match_guid]
    score.api_id = new_score[:api_id]
    score.updated_at = new_score[:date] if new_score[:date]
    score.save!
  end

  def self.mode_from_params(params)
    physics = if params[:physics]
                params[:physics]
              elsif params[:factory]
                params[:factory]
              else
                'turbo'
              end

    w = params.fetch(:weapons, 'true')
    weapons = ActiveRecord::Type::Boolean.new.type_cast_from_user(w)
    return weapons ? 2 : 3 if physics == 'classic'
    weapons ? 0 : 1
  end

  private_class_method :mode_from_params, :update_score
end
