module Commented
  extend ActiveSupport::Concern

  included do
    before_action :find_commented, only: %i[create_comment]
    after_action :publish_comment, only: %i[create_comment]
  end

  def create_comment
    @comment = @commented.comments.new(text: comment_params[:text])
    @comment.user = current_user
    if @comment.save
      render json: { comment: @comment, id: @comment.commentable_id }
    else
      render json: { errors: @comment&.errors&.full_messages, id: @comment.commentable_id }, status: :unprocessable_entity
    end
  end
  
  private
  
  def publish_comment
    return if @comment.errors.any?
    set_id
    ActionCable.server.broadcast "comments-for-#{@comment.commentable_type.underscore}-#{@id}",
      ApplicationController.render( json: { comment: @comment, id: @comment.commentable_id } )
  end

  def set_id
    if @comment.commentable_type == 'Question'
      @id = @comment.commentable_id
    else
      answer = Answer.find(@comment.commentable_id)
      @id = answer.question_id
    end
  end
  
  def find_commented
    @commented = model_klass.find(params[:id])
  end
  
  def model_klass
    controller_name.classify.constantize
  end
  
  def comment_params
    params.require(commentable.to_sym).permit(:text)
  end
  
  def commentable
    params[:commentable]
  end
end 
  