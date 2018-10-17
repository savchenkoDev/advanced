
class CommentsChannel < ApplicationCable::Channel
  def follow_question
    stream_from "comments-for-question"
  end

  def follow_answer
    stream_from "comments-for-answer"
  end
  
end