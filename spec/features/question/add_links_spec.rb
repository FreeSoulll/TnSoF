require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://github.com' }
  given(:google) { 'https://google.com' }
  given(:incorrect_url) { 'google' }

  describe 'User', js: true do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    scenario 'Adds link when asks question' do
      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'Adds links when ask a many questions' do
      click_on 'add link'

      within '#question-tasks .nested-fields:nth-child(2n)' do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: google
      end

      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'My gist', href: google
    end

    scenario 'Adds links when ask a question with incorrect url' do
      click_on 'add link'

      within '#question-tasks .nested-fields:nth-child(2n)' do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: incorrect_url
      end

      click_on 'Ask'

      expect(page).to have_content 'Links url Enter correct url'
    end
  end
end
