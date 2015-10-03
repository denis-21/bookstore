require 'rails_helper'

feature 'Add rating' do
  given(:user) { FactoryGirl.create(:user)}
  given!(:book) {FactoryGirl.create(:book)}
  before do
    login_as user
  end


  scenario 'user can see review page' do
    visit book_path(book.id)
    find('a.review').click
    expect(page).to have_content('New review for')
    expect(page).to have_content(book.title)
  end

  scenario 'user add rating' do
    visit new_book_rating_path(book.id)
    within '#new_rating' do
      fill_in 'rating[review]', with:Faker::Lorem.sentence
      click_on('ADD')
    end
    expect(page).to have_content('Your review is awaiting moderation')
  end
end