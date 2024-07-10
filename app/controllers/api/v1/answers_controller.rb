class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[edit update destroy]

  skip_before_action :verify_authenticity_token, only: %i[create destroy update]

  def show
    @answer = Answer.find(params[:id])

    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_resource_owner, question: @question))

    if @question.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body, links_attributes: %i[name url])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
