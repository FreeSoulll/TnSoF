require 'rails_helper'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { build(:question) }
    let(:question_by_user) { build(:question, user: user) }
    let(:question_by_other_user) { build(:question, user: other_user) }
    let(:answer_by_user) { build(:answer, user: user, question: question) }
    let(:answer_by_other_user) { build(:answer, user: other_user, question: question) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    # Questions

    it { should be_able_to :update, question_by_user, user: user }
    it { should_not be_able_to :update, question_by_other_user, user: user }

    it { should be_able_to :destroy, question_by_user, user: user }
    it { should_not be_able_to :destroy, question_by_other_user, user: user }

    it { should be_able_to :add_comment, question_by_user, user: user }
    it { should be_able_to :add_comment, question_by_other_user, user: user }

    # Questions-vote

    it { should be_able_to :up_vote, question_by_other_user, user: user }
    it { should_not be_able_to :up_vote, question_by_user, user: user }

    it { should be_able_to :down_vote, question_by_other_user, user: user }
    it { should_not be_able_to :down_vote, question_by_user, user: user }

    it { should be_able_to :add_vote, question_by_other_user, user: user }
    it { should_not be_able_to :add_vote, question_by_user, user: user }

    # Answers

    it { should be_able_to :update, answer_by_user, user: user }
    it { should_not be_able_to :update, answer_by_other_user, user: user }

    it { should be_able_to :destroy, answer_by_user, user: user }
    it { should_not be_able_to :destroy, answer_by_other_user, user: user }

    it { should be_able_to :add_comment, answer_by_user, user: user }
    it { should be_able_to :add_comment, answer_by_other_user, user: user }

    # Answers-vote

    it { should be_able_to :up_vote, answer_by_other_user, user: user }
    it { should_not be_able_to :up_vote, answer_by_user, user: user }

    it { should be_able_to :down_vote, answer_by_other_user, user: user }
    it { should_not be_able_to :down_vote, answer_by_user, user: user }

    it { should be_able_to :add_vote, answer_by_other_user, user: user }
    it { should_not be_able_to :add_vote, answer_by_user, user: user }
  end
end
