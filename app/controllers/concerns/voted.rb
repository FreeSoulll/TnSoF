module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[up_vote down_vote]
  end

  def up_vote
    return if current_user.author_of?(@votable)

    vote = @votable.votes.find_by(user: current_user)

    if vote
      vote.voted? ? @votable.vote_cancel(vote) : @votable.revert_vote(vote)
    else
      create_vote_up
    end

    json_data
  end

  def down_vote
    return if current_user.author_of?(@votable)

    vote = @votable.votes.find_by(user: current_user)

    if vote
      !vote.voted? ? @votable.vote_cancel(vote) : @votable.revert_vote(vote)
    else
      create_vote_down
    end

    json_data
  end

  private

  def set_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end

  def create_vote_up
    @votable.change_rating(1)
    @votable.votes.create(user: current_user, voted: true)
  end

  def create_vote_down
    @votable.change_rating(-1)
    @votable.votes.create(user: current_user, voted: false)
  end

  def json_data
    render json: {
      id: @votable.id,
      rating: @votable.rating
    }
  end
end
