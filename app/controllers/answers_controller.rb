class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :find_question, only: %i[index new create]
  before_action :find_answer, only: %i[show destroy]

  def index
    @answers = @question.answers
  end
  
  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to question_path(@answer.question), notice: 'Your answer successfully created.'
    else
      render :new, notice: 'Your answer was not created.'
    end
  end

  def show; end

  def destroy
    @answer.destroy if @answer.user == current_user
    redirect_to question_answers_path(@answer.question)
  end

  private
  
  def find_question
    @question = Question.find(params[:question_id])

  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
