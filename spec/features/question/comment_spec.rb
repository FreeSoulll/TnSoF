require 'rails_helper'

feature 'Authenticated user can comment for the question', %q{
  In order to like or dislike question
  As authenticated user and not author of question
  I'd like to be able to comment for the question
} do
  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }

    describe 'multiply sessions', js: true do
      scenario 'question appears on another users page' do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question.id)
        end

        Capybara.using_session('guest') do
          visit question_path(question.id)
        end

        Capybara.using_session('user') do
          within ".comment-#{question.id}-form" do
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
