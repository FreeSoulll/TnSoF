class SubscriptionsController < ApplicationController
  before_action :find_question
  authorize_resource

  def create
    @subscription = @question.subscriptions.create(user: current_user)

    respond_to do |format|
      if @subscription.persisted?
        format.js { render 'update_subscription' }
      end
    end
  end

  def destroy
    @subscription = @question.subscriptions.find_by(user: current_user)
    @subscription&.destroy
    respond_to do |format|
      format.js { render 'update_subscription' }
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
