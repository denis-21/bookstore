require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }
  let(:ability) { Ability.new(user) }
  let(:category) { FactoryGirl.create(:category) }

  before do
    sign_in user
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
  end

  describe 'category page' do
    it 'use books application layout ' do
      get :show, id:category
      expect(response).to render_template(layout: :books_aplication)
    end
  end

  describe 'GET #show' do
    context 'cancan doesnt allow :show' do
      before do
        ability.cannot :show, Category
        get :show, id:category
      end
      it { expect(response).to redirect_to(root_path) }
    end

    it 'assigns @category' do
      get :show, id:category
      expect(assigns(:category)).to eq (category)
    end
    it 'assigns @books' do
      get :show, id:category
      expect(assigns(:books)).to eq (category.books.page)
    end

    it 'renders the show template' do
      get :show, id:category
      expect(response).to render_template(:show)
    end
  end

end
