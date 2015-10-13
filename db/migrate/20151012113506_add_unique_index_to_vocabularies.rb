class AddUniqueIndexToVocabularies < ActiveRecord::Migration
  def change
    add_index :vocabularies, :word, unique: true
  end
end
