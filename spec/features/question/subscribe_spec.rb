require 'rails_helper'

feature 'User can subscribe on answer', %q{
  As an authenticated user
  I'd like to subscribe to question
} do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Authenticated user author', js: true do
    background do
      sign_in(author)
      visit question_path(question.id)
    end

    scenario 'change subscribe on unsubscribe' do
      within '.subscribes' do
        click_on 'Unsubscribe'
        expect(page).to have_button('Subscribe')
      end
    end
  end

  describe "Authenticated user not author dont subscribed", js: true do
    background do
      sign_in(user)
      visit question_path(question.id)
    end

    scenario 'see the correct subscription button' do
      within '.subscribes' do
        expect(page).to have_button('Subscribe')
      end
    end

    scenario 'subscribe on question' do
      within '.subscribes' do
        click_on 'Subscribe'
        expect(page).to have_button('Unsubscribe')
      end
    end
  end

  scenario 'Unauthenticated user tries to subscribe on question' do
    visit question_path(question.id)

    expect(page).to have_content 'Login'
  end
end
