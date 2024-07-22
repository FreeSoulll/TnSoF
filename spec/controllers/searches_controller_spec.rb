require 'sphinx_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #index' do
    it 'search in all resources' do
      expect(ThinkingSphinx).to receive(:search).with('test').and_return([])
      get :index, params: { query: 'test', chapter: 'All' }
    end

    it 'search in single resources' do
      expect(Question).to receive(:search).with('test').and_return([])
      get :index, params: { query: 'test', chapter: 'Question' }
    end

    it 'render index view' do
      get :index, params: { query: 'test', chapter: 'All' }
      expect(response).to render_template :index
    end
  end
end
