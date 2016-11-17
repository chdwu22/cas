class Timeslot < ApplicationRecord
  has_many :timeslot_users
  has_many :users, through: :timeslot_users
end
