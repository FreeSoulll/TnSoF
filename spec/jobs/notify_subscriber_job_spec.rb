require 'rails_helper'

RSpec.describe NotifySubscriberJob, type: :job do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe '#perform' do
    it 'calls the mailer to send an email to the author' do
      expect(NotifySubscriberMailer).to receive(:author)
                                            .with(user, answer, question)
                                            .and_return(double(deliver_later: true))
      described_class.new.perform(user, answer, question)
    end
  end
end
