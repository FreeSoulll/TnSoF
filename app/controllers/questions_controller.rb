class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  after_action :publish_question, only: %i[create]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
    @best_answer = @question.best_answer
    gon.question_id = @question.id
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_award
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
    return redirect_to(@question) unless current_user.author_of?(@question)

    @question.update(question_params)
  end

  def destroy
    if current_user.author_of?(@question)
      @question.update(best_answer_id: nil)
      @question.destroy
      redirect_to questions_path
    else
      redirect_to @question, notice: 'Not author cant delete the question'
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url], award_attributes: %i[title image])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(:questions, @question.to_json)
  end
end
