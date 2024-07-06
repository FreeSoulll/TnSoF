class BestAnswersController < ApplicationController
  authorize_resource

  def create
    @question = Question.find(params[:question_id])

    @best_answer = Answer.find(params[:best_answer_id])
    @other_answers = @question.answers.where.not(id: @best_answer.id)
    @question.update(best_answer_id: @best_answer.id)

    @question.award.update(user: @best_answer.user) if @question.award.present?
  end
end
