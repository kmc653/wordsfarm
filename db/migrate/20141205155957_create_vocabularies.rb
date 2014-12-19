class CreateVocabularies < ActiveRecord::Migration
  def change
    create_table :vocabularies do |t|
      t.string :word
      t.string :part_of_speech
      t.string :example
      t.timestamps
    end
  end
end
