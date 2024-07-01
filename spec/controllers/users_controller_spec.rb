require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #new' do
    before { get :new }

    it 'render index view' do
      expect(response).to render_template :new
    end
  end

  describe '#create_user' do
    before do
      session[:oauth_provider] = 'Vkontakte'
      session[:oauth_uid] = '123456'
    end

    describe 'with valid email' do
      subject { post :create_user, params: { user: { email: 'test@user.com' } } }

      it 'send confirm instructions' do
        subject
        mail = ActionMailer::Base.deliveries.last

        expect(mail.subject).to eq('Confirmation instructions')
      end

      it 'create user' do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'create authorizations' do
        expect { subject }.to change(Authorization, :count).by(1)
      end
    end

    describe 'with invalid email' do
      subject { post :create_user, params: { user: { email: '' } } }

      it 'not sent confirm instruictions' do
        subject
        mail = ActionMailer::Base.deliveries.last

        expect(mail).to eq(nil)
      end

      it 'not create user' do
        expect { subject }.to change(User, :count).by(0)
      end

      it 'not create authorizations' do
        expect { subject }.to change(Authorization, :count).by(0)
      end
    end
  end
end
