module ApplicationHelper
  def resource_name(resource)
    resource.class.name.underscore.to_s
  end

  def render_result(object)
    klass = object.class.to_s
    case klass
    when "Question" then render(partial: 'search/question', locals: { question: object } )    
    when "Answer" then render(partial: 'search/answer', locals: { answer: object } )    
    when "User" then render(partial: 'search/user', locals: { user: object } )
    when "Comment"
      partial = object.commentable_type == 'Question' ? 'search/question_comment' : 'search/answer_comment'
      render(partial: partial, locals: { comment: object } )
    end
  end
  
end
