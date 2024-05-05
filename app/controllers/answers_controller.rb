class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[edit update destroy]

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
      render 'questions/show'
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
    notice = current_user.author_of?(@answer) ? 'Your answer successfully delete' : 'Your answer not delete'

    @answer.destroy if current_user.author_of?(@answer)
    redirect_to question, notice: notice
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
