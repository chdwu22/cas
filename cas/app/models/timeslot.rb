class Timeslot < ApplicationRecord
  has_many :timeslot_users, dependent: :destroy
  has_many :users, through: :timeslot_users
end
