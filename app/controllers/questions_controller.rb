class QuestionsController < ApplicationController
  include Voted
  include Commented
  
  before_action :authenticate_user!, only: %i[new create show]
  before_action :find_question, only: %i[show edit update destroy comment]
  before_action :build_answer, only: :show
  after_action :publish_question, only: %i[create]
  
  authorize_resource
  
  respond_to :js, only: :update

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit; end

  def create
    respond_with @question = current_user.questions.create(question_params)
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy if current_user.author_of?(@question)
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions', ApplicationController.render(
      partial: 'questions/collection_item', locals: { question: @question }, layout: false
    )
  end
  
  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :destroy])
  end

  def build_answer
    @answer = @question.answers.build
  end
  
end
