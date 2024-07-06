module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: %i[add_comment]
    after_action :publish_comment, only: %i[add_comment]

    authorize_resource
  end

  def add_comment
    @comment = @commentable.comments.new(body: params[:body], user: current_user)

    if @comment.save
      commented_json_data
    else
      render json: @commentable.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def set_commentable
    @commentable = controller_name.classify.constantize.find(params[:id])
  end

  def commented_json_data
    render json: { comment: @comment }
  end

  def question_id
    @commentable.respond_to?(:question) ? @commentable.question.id : @commentable.id
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast("comments_#{question_id}_questions_and_answers", @comment.to_json(include: :user))
  end
end
