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

  # Associations
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  # Sanitize email
  before_save { email.downcase! }
  # can also be written as:
  # before_save { |user| user.email = user.email.downcase }

  # SSL Hijack prevention
  before_save :create_remember_token

  # Data validation
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  after_validation { self.errors.messages.delete(:password_digest) }
  validates :password_confirmation, presence: true

  # Utility methods

  def following?(other_user)
    self.relationships.find_by_followed_id(other_user.id)
    # Unless we're assigning values, we can write the above line like this:
    # relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
    # self.relationships.find_by_followed_id(other_user.id).destroy
  end

  def feed
    # This is only a proto-type
    Micropost.from_users_followed_by(self)
  end

 private
  # Create user's remember token
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end 

end
