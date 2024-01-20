# frozen_string_literal: true

# == Schema Information
#
# Table name: world_records
#
#  id         :integer          not null, primary key
#  map        :string           not null
#  match_guid :uuid             not null
#  mode       :integer          not null
#  time       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  api_id     :integer
#  player_id  :bigint           not null
#
# Indexes
#
#  index_world_records_on_map_and_mode  (map,mode) UNIQUE
#  index_world_records_on_player_id     (player_id)
#
# Foreign Keys
#
#  world_records_player_id_fk  (player_id => players.id) ON DELETE => cascade
#

class WorldRecord < ApplicationRecord
  belongs_to :player
  validates :map, :mode, :time, :match_guid, presence: true
  validates :mode, inclusion: {in: 0..3}
  validates :mode, uniqueness: {scope: :map,
                                message: "One record per mode for each map."}
  validates :time, numericality: {only_integer: true,
                                  greater_than: 0}

  def self.check(score)
    wr = world_record(score[:map], score[:mode])
    update_world_record(wr, score) if wr.time.nil? || score[:time] < wr.time
  end

  def self.map_scores
    query = <<-SQL.squish
    SELECT wr.map, wr.mode, wr.time, p.id AS player_id, p.name AS player_name
    FROM world_records wr
    INNER JOIN players p
    ON wr.player_id = p.id
    ORDER BY wr.map, wr.mode;
    SQL
    wrs = WorldRecord.find_by_sql [query]
    map_scores = Hash.new { |hash, key| hash[key] = Array.new(4) }
    wrs.each do |wr|
      map_scores[wr.map][wr.mode] = wr
    end
    map_scores
  end

  def self.world_record(map, mode)
    WorldRecord.find_or_initialize_by(map: map, mode: mode)
  end

  def self.most_world_records(mode)
    mode = mode.to_i
    mode = nil if mode == -1

    query = <<-SQL.squish
    SELECT wr.player_id, p.name, COUNT(wr.player_id) AS num_wrs,
        (SELECT COUNT(*)
         FROM scores
         WHERE scores.player_id = wr.player_id AND (:mode is null OR mode = :mode)) AS num_records
    FROM world_records wr, players p
    WHERE wr.player_id = p.id AND (:mode is null OR mode = :mode)
    GROUP BY p.name, wr.player_id
    ORDER BY num_wrs DESC
    SQL
    WorldRecord.find_by_sql [query, {mode: mode}]
  end

  def self.update_world_record(world_record, score)
    world_record.time = score[:time]
    world_record.player_id = score[:player_id]
    world_record.match_guid = score[:match_guid]
    world_record.api_id = score[:api_id]
    world_record.updated_at = score[:date] if score[:date]
    world_record.save!
  end

  private_class_method :update_world_record
end
