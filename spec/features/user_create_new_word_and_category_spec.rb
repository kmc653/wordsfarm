require 'spec_helper'

feature "User creates new word and category" do
  
  before do
    kevin = Fabricate(:user)
    login(kevin)
  end

  scenario "create a new word" do
    click_link "Add New Word 新增單字"
    fill_in_new_word
    page.should have_content "apple"
    page.should have_content "This is apple."
  end

  scenario "create a new category" do
    click_link "Create New Category 新增分類"
    fill_in_new_category
    page.should have_content "分類"
    page.should have_content "culture"
  end

  def fill_in_new_word
    fill_in "Word", with: 'apple'
    select "noun", from: 'Part of Speech'
    fill_in "Example", with: 'This is apple.'
    click_button "Add"
  end

  def fill_in_new_category
    click_link "Create New Category 新增分類"
    fill_in "Category's Name", with: 'culture'
    click_button "Create"
  end
end