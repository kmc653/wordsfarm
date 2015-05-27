module ApplicationHelper
  def has_no_category?(vocabulary)
    vocabulary.category_id == nil ? " " : Category.where(id: vocabulary.category_id).first.name
  end

  def collect_categories_array
    cate_array = current_user.categories.all.map { |category| [category.name, category.id] }
  end

  def collect_created_at_date(items)
    array = Array.new
    items.each do |vocabulary|
      date = vocabulary.created_at.to_date.to_s
      array.push(date)
    end
    array = array.uniq
  end

  def find_all_words_with_specific_date(items, date)
    word_array = Array.new
    items.each do |word|
      word_array.push(word) if word.created_at.to_date.to_s == date
    end
    word_array
  end
end