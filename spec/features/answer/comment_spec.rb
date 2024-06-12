require 'rails_helper'

feature 'Authenticated user can comment for the answer', %q{
  In order to like or dislike answer
  As authenticated user and not author of answer
  I'd like to be able to comment for the answer
} do
  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

    describe 'multiply sessions', js: true do
      scenario 'answer appears on another users page' do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question.id)
        end

        Capybara.using_session('guest') do
          visit question_path(question.id)
        end

        Capybara.using_session('user') do
          within ".answer-#{answer.id}" do
            fill_in 'Comment', with: 'Test comment'
            click_on 'New comment'
          end

          expect(page).to have_content 'Test comment'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Test comment'
        end
      end
    end

  end
end
