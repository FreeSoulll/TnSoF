class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: %i[show update destroy]

  skip_before_action :verify_authenticity_token, only: %i[create destroy update]

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_resource_owner

    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.update(best_answer_id: nil)
    @question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[name url])
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
