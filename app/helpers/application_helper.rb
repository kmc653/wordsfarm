module ApplicationHelper
  def has_no_category?(vocabulary)
    vocabulary.category_id == nil ? " " : Category.where(id: vocabulary.category_id).first.name
  end

  def collect_categories_array
    cate_array = current_user.categories.all.map { |category| [category.name, category.id] }
  end

  def bootstrap_class_for(flash_type)
    case flash_type
      when "success"
        "alert-success"   # Green
      when "error"
        "alert-danger"    # Red
      when "alert"
        "alert-warning"   # Yellow
      when "notice"
        "alert-info"      # Blue
      else
        flash_type.to_s
    end
  end
end