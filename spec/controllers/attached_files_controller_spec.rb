require 'rails_helper'

RSpec.describe AttachedFilesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author) }
  let!(:question_file) { question.files.attach(io: File.open("#{Rails.root}/spec/fixtures/files/test_file.txt"), filename: 'test_file.txt')}
  let!(:answer_file) { answer.files.attach(io: File.open("#{Rails.root}/spec/fixtures/files/test_file_2.txt"), filename: 'test_file_2.txt')}

  describe 'DELETE #destroy' do
    before { login(author) }

    context 'when deleting file from a question' do
      subject { delete :destroy, params: { question_id: question.id, attached_file: question.files.first.id }, format: :js }
      it 'deletes the attached file' do
        expect { subject }.to change(question.files, :count).by(-1)
      end
    end

    context 'when deleting file from an answer' do
      subject { delete :destroy, params: { answer_id: answer.id, attached_file: answer.files.first.id }, format: :js }
      it 'deletes the attached file' do
        expect { subject }.to change(answer.files, :count).by(-1)
      end
    end

    context 'when deleting file from an answer not a author' do
      before { login(user) }

      subject { delete :destroy, params: { answer_id: answer.id, attached_file: answer.files.first.id }, format: :js }
      it 'deletes the attached file' do
        expect { subject }.to_not change(answer.files, :count)
      end
    end

    context 'when deleting file from an question not a author' do
      before { login(user) }

      subject { delete :destroy, params: { question_id: question.id, attached_file: question.files.first.id }, format: :js }
      it 'deletes the attached file' do
        expect { subject }.to_not change(question.files, :count)
      end
    end
  end
end
