class Room < ApplicationRecord
  belongs_to :building
  has_many :courses
  validates :number, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true }
  validates :building_id, presence: true, numericality: { only_integer: true }
end
