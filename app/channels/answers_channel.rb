
class AnswersChannel < ApplicationCable::Channel
  def follow(params)
    stream_from "answers-for-question-#{params['id']}"
  end
  
end