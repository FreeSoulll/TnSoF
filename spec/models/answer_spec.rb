require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
  end

  describe 'validations' do
    it { should validate_presence_of :body }

    it 'must belong to a question' do
      answer = Answer.new
      expect(answer).not_to be_valid
      expect(answer.errors[:question]).to include('must exist')
    end
  end
end
