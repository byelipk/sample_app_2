# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  # Let's decide which attributes of our User model will be accessible to the outside world!
  attr_accessible :name, :email, :password, :password_confirmation

  # :password is provided by:
  # has_secure_password
  # If has_secure_password is unavailable, we will throw an exception

  # All emails entering the DB will be downcased
  before_save { email.downcase! }
  # can also be written as:
  # before_save { |user| user.email = user.email.downcase }
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

end
