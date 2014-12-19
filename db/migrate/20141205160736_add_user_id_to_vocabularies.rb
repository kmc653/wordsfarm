class AddUserIdToVocabularies < ActiveRecord::Migration
  def change
    add_column :vocabularies, :user_id, :integer
  end
end
