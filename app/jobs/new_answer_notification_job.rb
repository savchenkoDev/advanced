class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    question = answer.question
    question.subscribers.each do |user|
      NewAnswerNotificationMailer.subscribers_notification(answer, user).deliver_now
    end
  end
end
