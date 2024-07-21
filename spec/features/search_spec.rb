require 'sphinx_helper'

feature 'User can search resources', "
  In order to find needed resource
  As a User
  I'd like to be able to search for the resource
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'User searches all resources', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search-form' do
        fill_in 'Search text', with: 'MyString'
        click_on 'Search'
      end

      expect(page).to have_content 'Search results'
      expect(page).to have_content 'MyString'
      expect(page).to have_content 'Question'
    end
  end

  scenario 'User searches for the answer', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search-form' do
        fill_in 'Search text', with: 'MyText'
        page.select 'Answer', from: 'chapter'
        click_on 'Search'
      end

      expect(page).to have_content 'Search results'
      expect(page).to have_content 'MyText'
      expect(page).to have_content 'Answer'
      expect(page).to have_content 'Answer for Question - MyString'
    end
  end

  scenario 'search with not found resource', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search-form' do
        fill_in 'Search text', with: 'Testing'
        click_on 'Search'
      end

      expect(page).to have_content 'Search results'
      expect(page).to have_content 'No results found'
    end
  end

  scenario 'search with empty query', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search-form' do
        click_on 'Search'
      end

      expect(page).to have_content 'Search results'
      expect(page).to have_content 'No results found'
    end
  end
end
