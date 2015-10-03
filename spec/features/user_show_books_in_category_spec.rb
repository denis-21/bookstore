require 'rails_helper'

feature 'Categories' do
  given!(:category) { FactoryGirl.create(:category)}
  given!(:book) {FactoryGirl.create(:book,category: category)}

  scenario 'User can see books in selected category' do
    visit books_path
    click_link category.name
    expect(page).to have_content book.title
  end

  scenario 'A user can see categories on books page' do
    categories = []
    5.times { categories << FactoryGirl.create(:category) }
    visit books_path
    categories.each { |category| expect(page).to have_content category.name }
  end
end
