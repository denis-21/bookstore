Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'books#index'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { omniauth_callbacks: 'auth_facebook',registrations: 'registrations' }

  resources :books do
    resources :ratings, only: [:new, :create]
    post   'wish_list',  to: 'books#add_to_wishlist',      on: :member
    delete 'wish_list',  to: 'books#delete_from_wishlist', on: :member
    get    'wish_list',  to: 'books#wishlist',             on: :collection
  end
  resources :categories,  only: :show
  resources :order_items, only: [:destroy]
  resources :orders do
    get    'show_cart',  to: 'orders#show_cart',           on: :collection
  end
  resources :order_steps, only: [:index,:show, :update]



end
