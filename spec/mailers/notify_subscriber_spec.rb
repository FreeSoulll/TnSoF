require "rails_helper"

RSpec.describe NotifySubscriberMailer, type: :mailer do
  describe "author" do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: author) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:mail) { NotifySubscriberMailer.author(user, answer, question) }

    it 'renders the headers' do
      expect(mail.subject).to eq('New answer on question')
      expect(mail.to).to eq(['user2@test.com'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('MyString')
    end
  end
end
