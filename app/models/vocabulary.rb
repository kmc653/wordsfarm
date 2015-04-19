class Vocabulary < ActiveRecord::Base
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  belongs_to :category

  validates_presence_of :word, :part_of_speech, :example
  validates_presence_of :creator
  validates_uniqueness_of :word
end