require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answers) { create_list(:answer, 3, question: question, user: user) }
  let(:answer) { answers.first }

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: answer } }

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      subject { post :create, params: { answer: attributes_for(:answer), question_id: question.id }, format: :js }

      it 'saved a new answer in the database' do
        expect { subject }.to change(Answer, :count).by(1)
      end

      it 'renader question create tempalte' do
        subject
        expect(response).to render_template :create
      end

      it 'saved a new question in the database with user as author' do
        subject
        expect(user).to be_author_of(Answer.last)
      end
    end

    context 'with invalid attributes' do
      subject { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question.id }, format: :js }
      it 'does not the save the answer' do
        expect { subject }.to_not change(Answer, :count)
      end

      it 'renader question create tempalte' do
        subject
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let(:author) { create(:user) }
    let(:answer) { create(:answer, question: question, user: author) }
    before { login(author) }

    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

      it 'do not change answer' do
        answer.reload

        expect(answer.body).to eq 'MyText'
      end

      it 're-render edit view' do
        expect(response).to render_template :update
      end
    end

    context 'Not valid author' do
      before { login(user) }

      it 'not update the answer' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(answer.body).to eq 'MyText'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:author) { create(:user) }
    let!(:answer) { create(:answer, question: question, user: author) }
    before { login(author) }

    it 'delete the answer' do
      expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
    end

    context 'Not valid author' do
      before { login(user) }

      it 'not delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end
    end
  end
end
