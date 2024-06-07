module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_cancel(vote)
    vote.voted? ? change_rating(-1) : change_rating(1)
    vote.delete
  end

  def revert_vote(vote)
    if vote.voted?
      vote.update(voted: false)
      change_rating(-2)
    else
      vote.update(voted: true)
      change_rating(2)
    end
  end

  def change_rating(value)
    new_rating = value + rating
    update(rating: new_rating)
  end
end
