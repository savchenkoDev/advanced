class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :find_question, only: %i[index new create]
  before_action :find_answer, only: %i[update destroy]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update!(answer_params)
  end

  def destroy
    @answer.destroy! if current_user.author_of?(@answer)
  end

  private
  
  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id]) || Answer.new
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
