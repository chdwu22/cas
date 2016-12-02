class Room < ApplicationRecord
  has_many :courses
  validates :number, presence: true, uniqueness: true
  validates :capacity, presence: true, numericality: { only_integer: true }
end
