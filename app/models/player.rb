# == Schema Information
#
# Table name: players
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Player < ActiveRecord::Base
  has_many :scores
  has_many :world_records
  validates :name, presence: true

  def self.search(search)
    where('name ILIKE ?', "%#{search}%")
  end

  def self.update_player_name(id, name)
    player = Player.where(id: id).first_or_initialize
    if player.name != name
      player.name = name
      player.save!
    end
  end
end
