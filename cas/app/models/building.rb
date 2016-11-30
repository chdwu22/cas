class Building < ApplicationRecord
  #deprecated model
  has_many :rooms, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
