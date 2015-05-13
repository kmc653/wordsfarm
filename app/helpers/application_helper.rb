module ApplicationHelper
  def has_no_category?(vocabulary)
    vocabulary.category_id == nil ? " " : Category.where(id: vocabulary.category_id).first.name
  end

  def collect_categories_array
    cate_array = current_user.categories.all.map { |category| [category.name, category.id] }
  end
end