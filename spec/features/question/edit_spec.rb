require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question.id)

    expect(page).to_not have_content 'Edit question'
  end

  describe 'Author' do
    background do
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'spec_helper_test.rb')
      sign_in(author)
      visit question_path(question)
    end

    scenario 'edit his question', js: true do
      within '.question-info' do
        click_on 'Edit question'
        fill_in 'Question title', with: 'Test question'
        fill_in 'Question body', with: 'edited question'
        attach_file 'Question files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save question'

        expect(page).to have_content 'Test question'
        expect(page).to have_content 'edited question'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_link 'spec_helper_test.rb'
      end
    end

    scenario 'edits his question with errors', js: true do
      within '.question' do
        click_on 'Edit question'
        fill_in 'Question title', with: ''
        click_on 'Save question'

        expect(page).to have_content question.body
        expect(page).to have_content "Title can't be blank"
      end
    end

    scenario 'delete a file from question', js: true do
      within ".question-file-block .file-#{question.files.last.id}" do
        click_on 'x'
      end

      expect(page).to_not have_link 'spec_helper_test'
    end
  end

  scenario "Authenticated user tries to edit other user's question", js: true do
    sign_in(user)
    visit question_path(question)

    within '.question-info' do
      expect(page).to have_no_content 'Edit question'
    end
  end
end
