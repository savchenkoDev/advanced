class NewAnswerNotificationMailer < ApplicationMailer
  def subscribers_notification(answer)
    @question = answer.question
    @question.subscribers.each do |user|
      @greeting = "Hi #{user.email}!"
      @subscription = @question.subscriptions.where(user_id: user.id)
      @answer = answer
      mail to: user.email
    end
  end 
end
