class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[edit update destroy]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user, question: @question))
  end

  def update
    return redirect_to(@answer.question) unless current_user.author_of?(@answer)

    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, new_files: [])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
