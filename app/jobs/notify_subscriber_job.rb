class NotifySubscriberJob < ApplicationJob
  queue_as :default

  def perform(answer, question)
    SubscribeService.new.notify(answer, question)
  end
end
