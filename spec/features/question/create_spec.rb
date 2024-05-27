require 'rails_helper'

feature 'User can create', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text'
    end

    scenario 'asks a question with error' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text'
      attach_file 'Question files', ["#{Rails.root}/spec/fixtures/files/test_file.txt", "#{Rails.root}/spec/fixtures/files/test_file_2.txt"]
      click_on 'Ask'

      expect(page).to have_link 'test_file.txt'
      expect(page).to have_link 'test_file_2.txt'
    end

    scenario 'asks a question with create a award' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text'

      within '.award-block' do
        fill_in 'Award title', with: 'Test award'
        attach_file 'Award image', "#{Rails.root}/spec/fixtures/files/image.jpg"
      end
      click_on 'Ask'

      expect(page).to have_content 'Test award'
    end
  end

  scenario 'Unauthenticated user tries to asks a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
