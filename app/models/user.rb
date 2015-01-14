class User < ActiveRecord::Base
  validates_presence_of :email, :full_name, :password
  validates_uniqueness_of :email
  has_secure_password

  has_many :vocabularies
  has_many :queue_items

  before_create :generate_token

  def queued_word?(word)
    queue_items.map(&:vocabulary).include?(word)
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end