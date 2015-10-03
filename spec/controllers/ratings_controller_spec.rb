require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:ability) { Ability.new(user) }
  let(:book) { FactoryGirl.create(:book) }

  before do
    sign_in user
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
  end

  describe 'GET #new' do
    context 'cancan doesnt allow :new' do
      before do
        ability.cannot :new, Rating
        get :new, book_id: book.id
      end
      it { expect(response).to redirect_to(root_path) }
    end

    before do
      get :new, book_id: book.id
    end

    it 'assigns @book' do
      expect(assigns(:book)).to eq book
    end

    it 'renders the new template' do
      expect(response).to render_template :new
    end

  end

  describe 'POST #create' do
    let(:rating_params){FactoryGirl.attributes_for(:rating)}

    context 'cancan doesnt allow :create' do
      before do
        ability.cannot :create, Rating
        post :create, book_id: book.id,rating: rating_params
      end
      it { expect(response).to redirect_to(root_path) }
    end

    context 'with valid attributes' do

      it 'saves the new review in the database' do
        expect { post :create, book_id: book.id,rating: rating_params }.to change(Rating, :count).by(1)
      end

      it 'assigns a success flash message' do
        post :create, book_id: book.id, rating: rating_params
        expect(flash[:success]).not_to be_nil
      end

      it 'redirects to the book show template' do
        post :create, book_id: book.id, rating: rating_params
        expect(response).to redirect_to book_url(book)
      end
    end

    context 'with invalid attributes' do

      let(:rating_not_full_params){FactoryGirl.attributes_for(:rating,review: '')}

      it 'does not save the review' do
        expect { post :create, book_id: book.id, rating: rating_not_full_params }.to_not change(Rating, :count)
      end

      it 'redirects to the new template' do
        post :create, book_id: book.id, rating: rating_not_full_params
        expect(response).to render_template(:new)
      end
    end

  end

end
