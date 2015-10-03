require 'rails_helper'

feature 'User click book' do
  given(:user) { FactoryGirl.create(:user)}
  given!(:book) {FactoryGirl.create(:book)}
  given!(:rating) {FactoryGirl.create(:rating, book: book,user: user)}
  before do
    visit books_path
  end


  scenario 'User view book' do
    find(:xpath, "//a/img[@title='#{book.title}']/..").click
    expect(current_path).to eq(book_path(book.id))
    expect(page).to have_button 'Add to Cart'
    expect(page).to have_content  book.title
    expect(page).to have_content  book.price
    expect(page).to have_content  book.author.first_name
    expect(page).to have_content  book.description
    expect(page).to have_content  'Reviews'
    expect(page).to have_link  'Add review for this book'
  end

  scenario 'User login and view book' do
     login_as user
     find(:xpath, "//a/img[@title='#{book.title}']/..").click
     expect(current_path).to eq(book_path(book.id))
     expect(page).to have_button 'Add to Cart'
     expect(page).to have_content  book.title
     expect(page).to have_content  book.price
     expect(page).to have_content  book.author.first_name
     expect(page).to have_content  book.description
     expect(page).to have_content  'Reviews'
     expect(page).to have_link  'Add review for this book'
     expect(page).to have_css ('a.wish_list')
  end
end