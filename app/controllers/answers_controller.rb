class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[new show edit update destroy]

  def index; end

  def show; end

  def new; end

  def edit; end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created'
    else
      redirect_to @question, notice: 'Check the form fields'
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    question = @answer.question
    @answer.destroy if current_user.author?(@answer)

    redirect_to question, notice: 'Your answer successfully delete'
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
