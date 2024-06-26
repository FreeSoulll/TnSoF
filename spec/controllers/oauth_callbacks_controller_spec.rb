require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end
  describe 'sign_in_user' do
    let(:oauth_data) { mock_auth_hash('test@mail.ru') }

    it 'find user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq(user)
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user does not exists' do
      let(:oauth_data) { mock_auth_hash }

      before do
        @request.env['omniauth.auth'] = :oauth_data
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirect to new user path' do
        expect(response).to redirect_to(new_user_path)
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end

      it 'set correct session keys' do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        expect(User).to receive(:find_for_oauth).with(oauth_data)
        get :github

        expect(session[:oauth_provider]).to eq 'github'
        expect(session[:oauth_uid]).to eq '123545'
      end
    end
  end
end
