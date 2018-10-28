class AnswersController < ApplicationController
  include Voted
  include Commented
  
  before_action :authenticate_user!, only: %i[new create]
  before_action :find_question, only: %i[index new create]
  before_action :find_answer, only: %i[update destroy set_best]
  after_action :publish_answer, only: %i[create]
  
  authorize_resource
  
  respond_to :js, :json

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    respond_with @answer
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def set_best
    @question = @answer.question
    @answer.set_best if current_user.author_of?(@question)
  end

  private
  
  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id]) || Answer.new
  end

  def publish_answer
    return if @answer.errors.any?
    Rails.logger.info(@answer.attachments.each {|a| a})
    ActionCable.server.broadcast "answers-for-question-#{@answer.question_id}", 
      {
        answer: @answer,
        attachments:  @answer.attachments_attributes,
        rating: @answer.rating,
        question_author: @answer.question.user_id
      }
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :destroy])
  end
end
