class AddIndexUserIdToVocabularies < ActiveRecord::Migration
  def change
    add_index :vocabularies, :user_id
  end
end
