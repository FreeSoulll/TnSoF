require 'rails_helper'

RSpec.describe Award, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user).optional }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should have_one_attached(:image) }

    it 'have one attached file' do
      expect(Award.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
    end
  end
end
