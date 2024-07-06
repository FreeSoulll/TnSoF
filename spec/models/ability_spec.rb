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
    let(:question) { create(:question) }
    let(:question_by_user) { create(:question, user: user) }
    let(:question_by_other_user) { create(:question, user: other_user) }
    let(:answer_by_user) { create(:answer, user: user, question: question) }
    let(:answer_by_other_user) { create(:answer, user: other_user, question: question) }

    let(:question_file) { question.files.attach(io: File.open("#{Rails.root}/spec/fixtures/files/test_file_2.txt"), filename: 'test_file.txt')}
    let(:other_question_file) { question_by_other_user.files.attach(io: File.open("#{Rails.root}/spec/fixtures/files/test_file_2.txt"), filename: 'test_file.txt')}
    let(:answer_file) { answer.files.attach(io: File.open("#{Rails.root}/spec/fixtures/files/test_file_2.txt"), filename: 'test_file_2.txt')}
    let(:other_answer_file) { answer_by_other_user.files.attach(io: File.open("#{Rails.root}/spec/fixtures/files/test_file_2.txt"), filename: 'test_file_2.txt')}

    before do
      question_by_user.files.attach(io: File.open("#{Rails.root}/spec/fixtures/files/test_file_2.txt"), filename: 'test_file.txt')
      question_by_other_user.files.attach(io: File.open("#{Rails.root}/spec/fixtures/files/test_file_2.txt"), filename: 'test_file.txt')
    end

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    context 'questions' do
      it { should be_able_to :update, question_by_user }
      it { should_not be_able_to :update, question_by_other_user }

      it { should be_able_to :destroy, question_by_user }
      it { should_not be_able_to :destroy, question_by_other_user }

      it { should be_able_to :create_best_answer, question_by_user }
      it { should_not be_able_to :create_best_answer, question_by_other_user }

      # Questions-file

      it { should be_able_to :destroy, question_by_user.files.last }
      it { should_not be_able_to :destroy, question_by_other_user.files.last }

      # Questions-comments

      it { should be_able_to :add_comment, question_by_user }
      it { should be_able_to :add_comment, question_by_other_user }

      # Questions-links

      it { should be_able_to :destroy, create(:link, linkable: question_by_user, url: 'https://example.com') }
      it { should_not be_able_to :destroy, create(:link, linkable: question_by_other_user, url: 'https://example.com')}

      # Questions-vote

      it { should be_able_to :up_vote, question_by_other_user }
      it { should_not be_able_to :up_vote, question_by_user }

      it { should be_able_to :down_vote, question_by_other_user }
      it { should_not be_able_to :down_vote, question_by_user }

      it { should be_able_to :add_vote, question_by_other_user }
      it { should_not be_able_to :add_vote, question_by_user }
    end

    context 'answers' do
      it { should be_able_to :update, answer_by_user }
      it { should_not be_able_to :update, answer_by_other_user }

      it { should be_able_to :destroy, answer_by_user }
      it { should_not be_able_to :destroy, answer_by_other_user }

      # Answers-comments

      it { should be_able_to :add_comment, answer_by_user }
      it { should be_able_to :add_comment, answer_by_other_user }

      # Answers-links

      it { should be_able_to :destroy, create(:link, linkable: answer_by_user, url: 'https://example.com') }
      it { should_not be_able_to :destroy, create(:link, linkable: answer_by_other_user, url: 'https://example.com')}

      # Answers-vote

      it { should be_able_to :up_vote, answer_by_other_user }
      it { should_not be_able_to :up_vote, answer_by_user }

      it { should be_able_to :down_vote, answer_by_other_user }
      it { should_not be_able_to :down_vote, answer_by_user }

      it { should be_able_to :add_vote, answer_by_other_user }
      it { should_not be_able_to :add_vote, answer_by_user }
    end
  end
end
