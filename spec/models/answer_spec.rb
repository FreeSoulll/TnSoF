require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it_behaves_like 'Linkable'
  end

  describe 'validations' do
    it { should validate_presence_of :body }
    it { should have_many_attached(:files) }
    it { should accept_nested_attributes_for :links }

    it_behaves_like 'Attachmentable'
  end
end
