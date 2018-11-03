class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i[index create]

  def index
    @answers = @question.answers
    respond_with @answers
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer, serializer: SingleAnswerSerializer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    @answer.save
    render json: @answer, serializer: SingleAnswerSerializer
  end
  
  private

  def find_question
    @question = Question.find(params[:question_id])
  end
  

  def answer_params
    params.require(:answer).permit(:body)
  end
  

end