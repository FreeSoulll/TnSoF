class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "comments_#{params[:question_id]}_questions_and_answers"
  end
end
