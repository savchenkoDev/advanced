class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :find_user, only: %i[destroy]
  before_action :find_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
  end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: "Your question successfully created."
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy

    @question.destroy if @question.user == current_user
    redirect_to questions_path 
    
  end

  private

  def find_user
    @user = current_user
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
