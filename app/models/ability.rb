class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user&.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Comment, Subscription], user_id: user.id
    can :add_comment, [Question, Answer]
    can [:up_vote, :down_vote, :add_vote], [Question, Answer] do |voteable|
      voteable.user_id != user.id
    end

    can :destroy, Link, linkable: { user_id: user.id }
    can :create_best_answer, Question do |question|
      question.user_id == user.id
    end
    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end
  end
end
