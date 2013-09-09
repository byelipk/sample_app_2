class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  # Create associations; spcecify the User class
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
