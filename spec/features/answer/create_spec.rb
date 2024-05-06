require 'rails_helper'

feature 'User can create', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to create a answer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question.id)
    end

    scenario 'create answer', js: true do
      fill_in 'Body', with: 'text text'
      click_on 'Create answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'text text'
      end
    end

    scenario 'create a answer with error', js: true do
      click_on 'Create answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to create a answer' do
    visit question_path(question.id)

    expect(page).to have_content 'Login'
  end
end
