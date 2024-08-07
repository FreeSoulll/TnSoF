require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Your Daily Digest')
      expect(mail.to).to eq(['user1@test.com'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('MyString')
    end
  end
end
