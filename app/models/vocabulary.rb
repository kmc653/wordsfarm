class Vocabulary < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name ["wordsfarm", Rails.env].join('_')

  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  belongs_to :category

  validates_presence_of :word, :part_of_speech, :example
  validates_presence_of :creator
  validates_uniqueness_of :word

  def as_indexed_json(options={})
    as_json(
      only: [:word]
    )
  end
end