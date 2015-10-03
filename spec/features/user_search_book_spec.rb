require 'rails_helper'

feature 'User search book' do
  given!(:book) {FactoryGirl.create(:book)}
  given!(:book2) {FactoryGirl.create(:book)}
  before do
    visit books_path
  end

  context 'user not sing in' do
    scenario 'user can search book by title' do
      within '#search-form' do
        fill_in 'search', with: book2.title
        click_on('Search')
      end
      expect(page).to have_selector(:xpath, "//a/img[@title='#{book2.title}']/..")
      expect(page).to have_content(book2.price)
    end
    scenario 'user can search book by author' do
      within '#search-form' do
        fill_in 'search', with: book2.author.first_name
        click_on('Search')
      end
      expect(page).to have_selector(:xpath, "//a/img[@title='#{book2.title}']/..")
      expect(page).to have_content(book2.price)
    end
  end

  context 'user sing in' do
    given(:user) { FactoryGirl.create(:user)}
    before do
      login_as user
    end

    scenario 'user can search book by title' do
      within '#search-form' do
        fill_in 'search', with: book2.title
        click_on('Search')
      end
      expect(page).to have_selector(:xpath, "//a/img[@title='#{book2.title}']/..")
      expect(page).to have_content(book2.price)
    end
    scenario 'user can search book by author' do
      within '#search-form' do
        fill_in 'search', with: book2.author.first_name
        click_on('Search')
      end
      expect(page).to have_selector(:xpath, "//a/img[@title='#{book2.title}']/..")
      expect(page).to have_content(book2.price)
    end
  end

end