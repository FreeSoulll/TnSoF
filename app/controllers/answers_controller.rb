class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[edit update destroy]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user, question: @question))
  end

  def update
    @answer.update(answer_params)
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
