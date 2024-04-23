require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it 'has many answers' do
      association = described_class.reflect_on_association(:answers)
      expect(association.macro).to eq :has_many
    end
  end
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end
end
