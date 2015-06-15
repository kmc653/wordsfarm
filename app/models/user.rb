class User < ActiveRecord::Base
  include Tokenable

  validates_presence_of :email, :full_name, :password
  validates_uniqueness_of :email
  has_secure_password

  has_many :vocabularies, -> { order("created_at DESC") }
  has_many :queue_items, -> { order("created_at DESC") }
  has_many :categories

  has_many :following_relationships, class_name: 'Relationship', foreign_key: :follower_id
  has_many :leading_relationships, class_name: 'Relationship', foreign_key: :leader_id

  acts_as_messageable

  def queued_word?(word)
    queue_items.map(&:vocabulary).include?(word)
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

  def have_vocabularies?
    self.vocabularies.count != 0
  end

  def mailboxer_email(object)
    return email
  end
end