class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(object)
    NewAnswerNotificationMailer.subscribers_notification(object)
  end
end
