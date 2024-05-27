require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://github.com' }
  given(:google) { 'https://google.com' }
  given(:incorrect_url) { 'google' }

  describe 'User', js: true do
    background do
      sign_in(user)

      visit question_path(question)
      fill_in 'Body', with: 'My answer'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    scenario 'Adds link when give an answer' do
      click_on 'Create answer'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end
    end

    scenario 'Adds links when give an answer' do
      click_on 'add link'

      within '#answer-tasks .nested-fields:nth-child(2n)' do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: google
      end

      click_on 'Create answer'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'My gist', href: google
      end
    end

    scenario 'Adds links when give an answer with incorrect url' do
      click_on 'add link'

      within '#answer-tasks .nested-fields:nth-child(2n)' do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: incorrect_url
      end

      click_on 'Create answer'

      expect(page).to have_content 'Links url Enter correct url'
    end
  end
end
