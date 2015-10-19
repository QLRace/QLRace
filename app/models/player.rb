class Player < ActiveRecord::Base
  has_many :scores
  has_many :world_records
  validates :name, presence: true

  def self.search(search)
    where('name ILIKE ?', "#{search}%")
  end
end
