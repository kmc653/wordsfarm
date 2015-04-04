class Category < ActiveRecord::Base
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'

  validates_presence_of :name
  validates_uniqueness_of :name
end