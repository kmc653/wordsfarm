class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :vocabulary

  delegate :full_name, to: :user, prefix: :user
  delegate :word, to: :vocabulary, prefix: :vocabulary
  delegate :part_of_speech, to: :vocabulary, prefix: :vocabulary
  delegate :example, to: :vocabulary, prefix: :vocabulary
  delegate :creator, to: :vocabulary, prefix: :vocabulary
end