require 'rails_helper'

feature 'User can delete', %q{
  In order to delete
  As an authenticated user
  I'd like to be able to delete the answer
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Authorized' do
    scenario 'author delete a answer' do
      sign_in(author)
      visit question_path(question.id)
      click_on 'Delete answer'

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'Your answer successfully delete'
    end

    scenario 'not author cant delete a answer' do
      sign_in(user)
      visit question_path(question.id)
      click_on 'Delete answer'

      expect(page).to have_content answer.body
      expect(page).to have_content 'Your answer not delete'
    end
  end

  scenario 'not authorized user delete a question' do
    visit question_path(question.id)

    expect(page).to_not have_content 'Delete answer'
  end
end
