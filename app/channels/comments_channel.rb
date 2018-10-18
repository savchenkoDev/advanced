
class CommentsChannel < ApplicationCable::Channel
  def follow_question(params)
    stream_from "comments-for-question-#{params['id']}"
  end

  def follow_answer(params)
    stream_from "comments-for-answer-#{params['id']}"
  end
  
end