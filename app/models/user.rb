class User < ActiveRecord::Base
  validates_presence_of :email, :full_name, :password
  validates_uniqueness_of :email
  has_secure_password

  has_many :vocabularies
  has_many :queue_items

  has_many :following_relationships, class_name: 'Relationship', foreign_key: :follower_id
  has_many :leading_relationships, class_name: 'Relationship', foreign_key: :leader_id

  before_create :generate_token

  def queued_word?(word)
    queue_items.map(&:vocabulary).include?(word)
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def follow?(leader)
    following_relationships.map(&:leader).include?(leader)
  end

  def can_follow?(leader)
    !(self.follow?(leader) || self == leader)
  end

  def follow(another_user)
    following_relationships.create(leader: another_user)
  end
end