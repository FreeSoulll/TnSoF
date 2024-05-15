require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Author' do
    background do
      answer.files.attach(io: File.open("#{Rails.root}/spec/fixtures/files/test_file.txt"), filename: 'spec_helper_test.rb')
      sign_in(author)
      visit question_path(question)
    end

    scenario 'edit his answer', js: true do
      within ".answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        attach_file 'Add files', ["#{Rails.root}/spec/fixtures/files/test_file.txt", "#{Rails.root}/spec/fixtures/files/test_file_2.txt"]
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_link 'test_file.txt'
        expect(page).to have_link 'test_file_2.txt'
      end
    end

    scenario 'delete a file from answer', js: true do
      within ".answers-file-block .file-#{answer.files.last.id}" do
        click_on 'x'
      end

      expect(page).to_not have_link 'spec_helper_test.rb'
    end

    scenario 'edits his answer with errors', js: true do
      within ".answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario "Authenticated user tries to edit other user's answer", js: true do
    sign_in(user)
    visit question_path(question)

    within ".answer-#{answer.id}" do
      expect(page).to have_no_content 'Edit'
    end
  end
end
