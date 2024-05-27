require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '#gist?' do
    let(:github_gist_link) { build(:link, url: 'https://gist.github.com/username/12345678') }
    let(:non_github_link) { build(:link, url: 'https://example.com') }

    it 'returns true if URL is a GitHub gist' do
      expect(github_gist_link.gist?).to be_truthy
    end

    it 'returns false if URL is not a GitHub gist' do
      expect(non_github_link.gist?).to be_falsey
    end
  end

  describe '#gist_token' do
    let(:link_with_gist) { build(:link, url: 'https://gist.github.com/username/12345678') }

    it 'extracts the token from a GitHub gist URL' do
      expect(link_with_gist.gist_token).to eq('12345678')
    end
  end
end
