require 'rails_helper'

RSpec.describe BestAnswersController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:author) { create(:user) }
    let(:question) { create(:question, user: author) }
    let(:answer) { create(:answer, question: question, user: author) }
    let!(:question_award) { create(:award, question: question) }

    context 'when author sets the best answer' do
      before do
        login(author)
        post :create, params: { question_id: question.id, best_answer_id: answer.id }, format: :js
        question.reload
      end

      it 'make answer a best' do
        expect(question.best_answer_id).to eq(answer.id)
        expect(question.award).to eq(question_award)
      end
    end

    context 'when another user tries to set the best answer' do
      before do
        login(user)
        post :create, params: { question_id: question.id, best_answer_id: answer.id }, format: :js
        question.reload
      end

      it 'try a make answer a best to another author' do
        expect(question).to have_attributes(best_answer_id: nil)
      end
    end
  end
end
