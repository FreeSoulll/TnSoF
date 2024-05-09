class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy set_the_best_answer]
  before_action :other_answers, only: %i[show set_the_best_answer]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @best_answer = @question.best_answer
  end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    return unless current_user.author_of?(@question)

    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy if current_user.author_of?(@question)
    redirect_to questions_path
  end

  def set_the_best_answer
    return redirect_to(@question) unless current_user.author_of?(@question)

    @best_answer = Answer.find(params[:best_answer_id])
    @question.update(best_answer: @best_answer)
  end

  private

  def other_answers
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
