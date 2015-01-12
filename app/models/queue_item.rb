class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :vocabulary

  delegate :full_name, to: :user, prefix: :user
  delegate :word, to: :vocabulary, prefix: :vocabulary

end