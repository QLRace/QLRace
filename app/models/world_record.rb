# == Schema Information
#
# Table name: world_records
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

class WorldRecord < ActiveRecord::Base
  belongs_to :player
  validates :map, :mode, :player_id, :time, presence: true
  validates_inclusion_of :mode, in: 0..3
  validates :player, presence: true
  validates :mode, uniqueness: { scope: :map,
                                 message: 'One record per mode for each map.' }

  def self.check(score)
    wr = world_record(score[:map], score[:mode])
    update_world_record(wr, score) if wr.time.nil? || score[:time] < wr.time
  end

  def self.map_scores
    map_scores = []
    wrs = WorldRecord.order(:mode).includes(:player)
    WorldRecord.order(:map).distinct(:map).pluck(:map).each do |map|
      map_scores << wrs.where(map: map)
    end
    map_scores
  end

  private

  def self.world_record(map, mode)
    WorldRecord.where(map: map, mode: mode).first_or_initialize
  end

  def self.update_world_record(world_record, score)
    world_record.time = score[:time]
    world_record.player_id = score[:player_id]
    world_record.match_guid = score[:match_guid]
    world_record.api_id = score[:api_id]
    world_record.updated_at = score[:date] if score[:date]
    world_record.save!
  end
end
