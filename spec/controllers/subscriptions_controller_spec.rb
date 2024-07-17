require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { login(user) }
    subject { post :create, params: { question_id: question.id }, format: :js }

    it 'create new subscription' do
      expect { subject }.to change(Subscription, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscribe) { create(:subscription, user: user, question: question) }
    before { login(user) }

    it 'Unsubscribe questions' do
      expect { delete :destroy, params: { question_id: question }, format: :js }.to change(Subscription, :count).by(-1)
    end
  end
end
