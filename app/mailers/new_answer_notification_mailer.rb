class NewAnswerNotificationMailer < ApplicationMailer
  def question_author_notification(answer)
    @question = answer.question
    question_author = @question.user
    @greeting = "Hi #{question_author.email}!"
    @answer = answer
    mail to: question_author.email
  end
  
end
