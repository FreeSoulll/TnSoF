require 'rails_helper'

describe 'Answers API', type: :request do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:headers) {{"CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json'}}

  describe 'DELETE /api/v1/answers/:id/' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user, question: question) }
    let(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API Deletable', Answer
  end

  describe 'UPDATE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:resource) { create(:answer, user: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{resource.id}" }
    let(:access_token) { create(:access_token) }
    let(:update_params) do
      {
        'body': 'new answer body'
      }
    end

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    it_behaves_like 'API Updatable', Answer
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user, question: question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    it_behaves_like 'API Creatable', Answer
  end

  describe 'GET /api/v1/answers/:id' do
    let(:resource) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{resource.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:resource_file) { resource.files.attach(io: File.open("#{Rails.root}/spec/fixtures/files/test_file.txt"), filename: 'test_file.txt')}
      let!(:resource_link) { create(:link, linkable: resource) }
      let!(:resource_comment) { create(:comment, user_id: user.id, commentable: resource) }
      let(:resource_response) { json['answer'] }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'API Getable', 'status'
      it_behaves_like 'API Getable', 'object'

      it 'returns all public fields' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(resource_response[attr]).to eq resource.send(attr).as_json
        end
      end

      describe 'files' do
        it_behaves_like 'API Getable', 'files'
      end

      describe 'links' do
        it_behaves_like 'API Getable', 'links'
      end

      describe 'comments' do
        it_behaves_like 'API Getable', 'comments'
      end
    end
  end
end
