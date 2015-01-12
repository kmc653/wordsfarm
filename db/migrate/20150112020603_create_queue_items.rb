class CreateQueueItems < ActiveRecord::Migration
  def change
    create_table :queue_items do |t|
      t.integer :word_id, :user_id
      t.timestamps
    end
  end
end
