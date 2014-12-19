class Vocabulary < ActiveRecord::Base
  validates_presence_of :word, :part_of_speech, :example
  validates_uniqueness_of :word

  belongs_to :user
end