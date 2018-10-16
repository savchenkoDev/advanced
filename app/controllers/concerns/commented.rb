module Commented
  extend ActiveSupport::Concern

  included do
    before_action :find_commented, only: %i[create_comment]
  end

  def create_comment
    @comment = @commented.comments.new(text: comment_params[:text])
    @comment.user = current_user
    if @comment.save
      render json: @comment
    else
      render json: @comment&.errors&.messages, status: :unprocessable_entity
    end
  end
  

  private

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
  