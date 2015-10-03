require 'rails_helper'

RSpec.describe AuthFacebookController, type: :controller do
  let(:auth) do
    user = attributes_for :facebook_user
    double("auth",
           provider: user[:provider],
           uid: user[:uid],
           info: double("info",
                        email: user[:email],

           )
    )
  end


  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['omniauth.auth'] = auth
    get :facebook
  end

  it 'redirect to root' do
    expect(response).to redirect_to(:root)
  end

  it 'success flash' do
    expect(flash[:notice]).not_to be_nil
  end


end
