require 'rails_helper'

feature 'User can delete', %q{
  In order to delete
  As an authenticated user
  I'd like to be able to delete the question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authorized' do
    scenario 'author delete a question' do
      sign_in(author)
      visit question_path(question.id)
      click_on 'Delete question'

      expect(page).to_not have_content question.title
    end

    scenario 'not author delete a question' do
      sign_in(user)
      visit question_path(question.id)
      click_on 'Delete question'

      expect(page).to have_content question.title
    end
  end

  scenario 'not authorized user delete a question' do
    visit question_path(question.id)

    expect(page).to_not have_content 'Delete question'
  end
end
