class SubscribeService
  def notify(answer, question)
    subscriptions = Subscription.includes(:user).where(question_id: question.id)
    subscriptions.each do |subscription|
      user = subscription.user
      NotifySubscriberMailer.author(user, answer, question).deliver_later
    end
  end
end
