class NotifySubscriberMailer < ApplicationMailer
  def author(user, answer, question)
    @question = question
    @answer = answer

    mail(to: user.email, subject: 'New answer on question')
  end
end
