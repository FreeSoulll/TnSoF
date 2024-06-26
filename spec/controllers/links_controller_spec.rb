require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:user) { create(:user) }
  let!(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author) }
  let!(:question_link) { create(:link, linkable: question) }
  let!(:answer_link) { create(:link, linkable: answer) }

  describe 'DELETE #destroy' do
    before { login(author) }

    context 'when deleting link from a question' do
      subject { delete :destroy, params: { link_id: question_link.id }, format: :js }
      it 'deletes the attached link' do
        expect { subject }.to change(question.links, :count).by(-1)
      end
    end

    context 'when deleting link from an answer' do
      subject { delete :destroy, params: { link_id: answer_link.id }, format: :js }
      it 'deletes the attached link' do
        expect { subject }.to change(answer.links, :count).by(-1)
      end
    end

    context 'when deleting link from an answer not a author' do
      before { login(user) }

      subject { delete :destroy, params: { link_id: answer_link.id }, format: :js }
      it 'deletes the attached link' do
        expect { subject }.to_not change(answer.links, :count)
      end

      it 'redirects to the linkable resource with a notice' do
        subject
        expect(response).to redirect_to(answer_link.linkable_type.constantize.find(answer_link.linkable_id))
        expect(flash[:notice]).to eq("Not author can't delete the #{answer_link.linkable_type} link")
      end
    end

    context 'when deleting links from an question not a author' do
      before { login(user) }

      subject { delete :destroy, params: { link_id: question_link.id }, format: :js }
      it 'deletes the attached links' do
        expect { subject }.to_not change(question.links, :count)
      end

      it 'redirects to the linkable resource with a notice' do
        subject
        expect(response).to redirect_to(question_link.linkable_type.constantize.find(question_link.linkable_id))
        expect(flash[:notice]).to eq("Not author can't delete the #{question_link.linkable_type} link")
      end
    end
  end
end
