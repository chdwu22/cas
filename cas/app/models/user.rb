class User < ApplicationRecord
  has_many :courses
  has_many :timeslot_users
  has_many :timeslots, through: :timeslot_users
  
  before_save { self.email = email.downcase}
  
  validates :first_name, presence: true, length: { minimum: 2, maximum: 25 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 25 }
  validates :full_name, uniqueness: { case_sensitive: false }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 105 }, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
  
  has_secure_password
end
