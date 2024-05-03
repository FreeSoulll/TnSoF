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

    scenario 'create answer' do
      fill_in 'Body', with: 'text text'
      click_on 'Create answer'

      expect(page).to have_content 'Your answer successfully created'
    end

    scenario 'create a answer with error' do
      click_on 'Create answer'

      expect(page).to have_content 'Check the form fields'
    end
  end

  scenario 'Unauthenticated user tries to create a answer' do
    visit question_path(question.id)

    expect(page).to_not have_content 'Create answer'
  end
end
