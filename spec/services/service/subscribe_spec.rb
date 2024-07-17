require 'rails_helper'

RSpec.describe SubscribeService do
  let(:users) { create_list(:user, 3) }

  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:subscription1) { create(:subscription, user: user1, question: question) }
  let!(:subscription2) { create(:subscription, user: user2, question: question) }

  before do
    allow(NotifySubscriberMailer).to receive_message_chain(:author, :deliver_later)
  end

  it 'sends an email to each subscriber of the question' do
    SubscribeService.new.notify(answer, question)

    expect(NotifySubscriberMailer).to have_received(:author).with(user1, answer, question).once
    expect(NotifySubscriberMailer).to have_received(:author).with(user2, answer, question).once
  end

  it 'does not send emails when there are no subscriptions' do
    Subscription.destroy_all

    SubscribeService.new.notify(answer, question)

    expect(NotifySubscriberMailer).not_to have_received(:author)
  end
end
