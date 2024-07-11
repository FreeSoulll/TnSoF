require 'rails_helper'

describe 'Questions API', type: :request do
  let(:user) { create(:user) }
  let!(:resource) { create(:question, user: user) }
  let(:access_token) { create(:access_token) }
  let(:headers) {{"CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json'}}
  let(:api_path) { '/api/v1/questions' }

  describe 'DELETE /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{resource.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API Deletable', Question
  end

  describe 'UPDATE /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{resource.id}" }
    let(:update_params) do
      {
        'body': 'new question body'
      }
    end

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    it_behaves_like 'API Updatable', Question
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    it_behaves_like 'API Creatable', Question
  end

  describe 'GET /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{resource.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:resource_file) { resource.files.attach(io: File.open("#{Rails.root}/spec/fixtures/files/test_file.txt"), filename: 'test_file.txt')}
      let!(:resource_link) { create(:link, linkable: resource) }
      let!(:resource_comment) { create(:comment, user_id: user.id, commentable: resource) }
      let(:resource_response) { json['question'] }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(resource_response[attr]).to eq resource.send(attr).as_json
        end
      end

      it_behaves_like 'API Getable', 'status'
      it_behaves_like 'API Getable', 'object'

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

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let!(:question) { questions.last }
      let!(:resource_file) { question.files.attach(io: File.open("#{Rails.root}/spec/fixtures/files/test_file.txt"), filename: 'test_file.txt')}
      let!(:resource_link) { create(:link, linkable: question) }
      let!(:resource_comment) { create(:comment, user_id: user.id, commentable: question) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:resource_response) { json['questions'].last }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(resource_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(resource_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(resource_response['short_title']).to eq 'MySt...'
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

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { resource_response['answers'].first }

        it 'returns list of answers' do
          expect(resource_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end
end
