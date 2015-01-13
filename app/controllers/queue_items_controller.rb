class QueueItemsController < ApplicationController
  before_action :require_user

  def create
    word = Vocabulary.find(params[:vocabulary_id])
    queue_word(word)
    redirect_to user_path(word.creator)
  end

  def destroy
    item = QueueItem.find(params[:id])
    item.destroy if current_user.queue_items.include?(item)
    redirect_to user_path(current_user)
  end


  private

  def queue_word(word)
    QueueItem.create(vocabulary: word, user: current_user) unless current_user_queued_word?(word)
  end

  def current_user_queued_word?(word)
    current_user.queue_items.map(&:vocabulary).include?(word)
  end
end