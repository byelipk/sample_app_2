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
  has_secure_password

  before_save { email.downcase! }
  # can also be written as:
  # before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  after_validation { self.errors.messages.delete(:password_digest) }
  validates :password_confirmation, presence: true

 private
  # Create user's remember token
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end 

end
