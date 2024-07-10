require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers) }
    it { should have_many(:answers).dependent(:destroy) }
    it_behaves_like 'Linkable'
    it { should have_one(:award).dependent(:destroy) }
  end
  describe 'validations' do
    it { should accept_nested_attributes_for :links }
    it { should accept_nested_attributes_for :award }
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should have_many_attached(:files) }

    it_behaves_like 'Attachmentable'
  end
end
