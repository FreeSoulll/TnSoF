require 'rails_helper'

feature 'User can choose best answer', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to set the best question
} do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:any_answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated user author', js: true do
    background do
      sign_in(author)

      visit question_path(question.id)
      within ".answer-#{answer.id}" do
        click_on 'Mark the best'
      end
    end

    scenario 'choose a best answer when a author' do
      within '.current-best-answer span' do
        expect(page).to have_content answer.body
      end

      within '.current-best-answer span' do
        expect(page).to have_content answer.body
      end
    end

    scenario 'choose another best answer when a author' do
      within ".answer-#{any_answer.id}" do
        click_on 'Mark the best'
      end

      within '.current-best-answer span' do
        expect(page).to have_content any_answer.body
      end

      within '.current-best-answer span' do
        expect(page).to have_content any_answer.body
      end
    end
  end

  scenario 'choose a best answer when not a author' do
    sign_in(user)
    visit question_path(question.id)

    within ".answer-#{answer.id}" do
      expect(page).to_not have_content 'Mark the best'
    end
  end

  scenario 'Unauthenticated user tries to make asnwer a best' do
    visit question_path(question.id)

    expect(page).to have_content 'Login'
  end
end
