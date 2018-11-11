class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(object)
    NewAnswerNotificationMailer.question_author_notification(object)
  end
end
