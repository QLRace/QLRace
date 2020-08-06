# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Player < ApplicationRecord
  has_many :scores, dependent: :destroy
  has_many :world_records, dependent: :destroy
  validates :name, presence: true

  def self.search(search)
    where('name ILIKE ?', "%#{search}%")
  end

  def self.update_player_name(id, name)
    player = Player.find_or_initialize_by(id: id)
    name = name.gsub(/\^[0-9]/, '') # remove colour codes from names
    return unless player.name != name

    player.name = name.presence || id
    player.save!
  end
end
