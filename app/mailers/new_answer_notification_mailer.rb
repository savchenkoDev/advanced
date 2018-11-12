class NewAnswerNotificationMailer < ApplicationMailer
  def subscribers_notification(answer, user)
    @question = answer.question
    @greeting = "Hi #{user.email}!"
    @answer = answer

    mail to: user.email
  end 
end
