class Course < ApplicationRecord
  belongs_to :room
  belongs_to :user
  validates :number, presence: true
  validates :name, presence: true
end
