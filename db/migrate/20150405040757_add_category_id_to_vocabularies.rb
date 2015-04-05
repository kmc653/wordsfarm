class AddCategoryIdToVocabularies < ActiveRecord::Migration
  def change
    add_column :vocabularies, :category_id, :integer
  end
end
