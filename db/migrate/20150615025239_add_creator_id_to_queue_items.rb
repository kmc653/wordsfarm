class AddCreatorIdToQueueItems < ActiveRecord::Migration
  def change
    add_column :queue_items, :creator_id, :integer
  end
end
