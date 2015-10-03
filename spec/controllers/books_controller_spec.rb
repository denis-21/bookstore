require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }
  let(:ability) { Ability.new(user) }
  let(:book) { FactoryGirl.create(:book) }

  before do
    sign_in user
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
  end

  describe 'books page' do
    it 'use books application layout ' do
      get :index
      expect(response).to render_template(layout: :books_aplication)
    end
  end

  describe 'GET #index' do
    context 'cancan doesnt allow :index' do
      before do
        ability.cannot :index, Book
        get :index
      end
      it { expect(response).to redirect_to(root_path) }
    end

    it 'call #page on Book' do
      expect(Book).to receive(:page)
      get :index
    end

    it 'call #search if search params' do
      expect(Book).to receive_message_chain(:search, :page)
      get :index, search: book.title
    end

    it 'assigns @books' do
      get :index
      expect(assigns(:books)).to match_array [book]
    end

    context 'search' do
      it 'assigns @books when search' do
        book1 = FactoryGirl.create(:book)
        book2 = FactoryGirl.create(:book)

        get :index, search: book2.title
        expect(assigns(:books)).to match_array [book2]
      end
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

  end

  describe 'GET #show' do
    context 'cancan doesnt allow :show' do
      before do
        ability.cannot :show, Book
        get :show, id: book.id
      end
      it { expect(response).to redirect_to(root_path) }
    end

    let(:book){FactoryGirl.create(:book_with_rating)}
    before { get :show, id: book.id }

    it 'assigns @book' do
      expect(assigns(:book)).to eq book
    end

    it 'assigns the book reviews to @ratings' do
      expect(assigns(:ratings)).to eq book.ratings.approved
    end

    it 'renders the show template' do
      expect(response).to render_template(:show)
    end

  end

  describe 'POST #add_to_wishlist' do

    context 'cancan doesnt allow :add_to_wishlist' do
      before do
        ability.cannot :add_to_wishlist, Book
        post :add_to_wishlist, id: book.id
      end
      it { expect(response).to redirect_to(root_path) }
    end

    context 'book is not wish list' do

      it 'save in the database ' do
        expect { post :add_to_wishlist, id: book.id }.to change(user.books, :count).by(1)
      end
      it 'assigns a success flash message' do
        post :add_to_wishlist, id: book.id
        expect(flash[:success]).not_to be_nil
      end
      it 'redirects to book show template' do
        post :add_to_wishlist, id: book.id
        expect(response).to redirect_to book_path(book)
      end

    end

    context 'book already exist in wish list' do
      before do
        post :add_to_wishlist, id: book.id
      end

      it 'does not save in the database' do
        expect { post :add_to_wishlist, id: book.id }.to_not change(user.books, :count)
      end

      it 'assigns a danger flash message' do
        post :add_to_wishlist, id: book.id
        expect(flash[:danger]).not_to be_nil
      end

      it 'redirects to book show template' do
        post :add_to_wishlist, id: book.id
        expect(response).to redirect_to book_path(book)
      end

    end

  end

  describe 'GET #wishlist' do

    context 'cancan doesnt allow :wishlist' do
      before do
        ability.cannot :wishlist, Book
        get :wishlist
      end
      it { expect(response).to redirect_to(root_path) }
    end

    before { get :wishlist }

    it 'return all books in Wish List' do
      user.add_to_wishlist(book)
      expect(assigns(:books)).to match_array(user.books)
    end
    it 'renders the wish list template' do
      expect(response).to render_template(:wishlist)
    end

  end

  describe 'DELETE #delete_from_wishlist' do

    context 'cancan doesnt allow :delete_from_wishlist' do
      before do
        ability.cannot :delete_from_wishlist, Book
        delete :delete_from_wishlist, id: book
      end
      it { expect(response).to redirect_to(root_path) }
    end

    context 'book exist in wish list' do
      before do
        user.add_to_wishlist(book)
      end

      it 'delete a book from wish list' do
        expect { delete :delete_from_wishlist, id: book }.to change(user.books, :count).by(-1)
      end
      it 'assigns a success flash message' do
        delete :delete_from_wishlist, id: book
        expect(flash[:warning]).not_to be_nil
      end

      it 'redirects to the wish list' do
        delete :delete_from_wishlist, id: book
        expect(response).to redirect_to wish_list_books_path
      end

    end

    context 'book is not wish list'  do
      it 'assigns a success flash message' do
        delete :delete_from_wishlist, id: book
        expect(flash[:danger]).not_to be_nil
      end

      it 'redirects to the wish list' do
        delete :delete_from_wishlist, id: book
        expect(response).to redirect_to wish_list_books_path
      end

    end

  end

end
