class BestAnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    return redirect_to(@question) unless current_user.author_of?(@question)

    @best_answer = Answer.find(params[:best_answer_id])
    @other_answers = @question.answers.where.not(id: @best_answer.id)
    @question.update(best_answer_id: @best_answer.id)
  end
end
