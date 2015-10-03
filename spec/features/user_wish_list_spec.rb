require 'rails_helper'

feature 'User Wish List' do
  given(:user) { FactoryGirl.create(:user)}
  given!(:book) {FactoryGirl.create(:book)}

  scenario 'A user should see no books when wish list is empty' do
    user2 = FactoryGirl.create(:user)
    login_as(user2)
    visit root_path
    click_link('Wish list')
    expect(page).to have_selector('h2', text: 'Wish List')
    expect(current_path).to eq(wish_list_books_path)
  end

  scenario 'User add book in wish list' do
    login_as user
    visit book_path(book.id)
    find("a.wish_list").click
    expect(page).to have_content  'This book successfully added to Wish list '
    expect(current_path).to eq(book_path(book.id))
  end

  context 'book add wish list' do
    before do
      login_as user
      visit book_path(book.id)
      find("a.wish_list").click
    end

    scenario 'User see in wish list to click link header' do
      click_link('Wish list')
      expect(page).to have_selector('h2', text: 'Wish List')
      expect(page).to have_link('Remove')
      expect(current_path).to eq(wish_list_books_path)

    end

    scenario 'User see in wish list to click link in book page' do
      click_link('In wish list')
      expect(page).to have_selector('h2', text: 'Wish List')
      expect(page).to have_link('Remove')
      expect(current_path).to eq(wish_list_books_path)
    end

    scenario 'User remove book in wish list' do
      visit wish_list_books_path
      click_link('Remove')
      expect(page).to have_selector('h2', text: 'Wish List')
      expect(current_path).to eq(wish_list_books_path)
      expect(page).to have_content("#{book.title} successfully removed from Wish list")
    end

  end
end
