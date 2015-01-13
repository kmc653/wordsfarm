class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :queue_items, :word_id, :vocabulary_id
  end
end