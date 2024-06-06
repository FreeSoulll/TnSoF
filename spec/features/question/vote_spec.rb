require 'rails_helper'

feature 'Authenticated user can vote for the question', %q{
  In order to like or dislike question
  As authenticated user and not author of question
  I'd like to be able to vote for the question
} do
  given!(:author)    { create(:user) }
  given!(:user)      { create(:user) }
  given!(:question)  { create(:question, user: author) }

  describe 'Authenticated user and not author of question', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'vote up per answer' do
      within '.question-info' do
        click_on 'Vote up'

        within ".rating-count-#{question.id}" do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'vote up twice per question (cancel vote)' do
      within '.question-info' do
        click_on 'Vote up'
        click_on 'Vote up'

        within ".rating-count-#{question.id}" do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'vote down per answer' do
      within '.question-info' do
        click_on 'Vote down'

        within ".rating-count-#{question.id}" do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'vote down twice per answer (cancel vote)' do
      within '.question-info' do
        click_on 'Vote down'
        click_on 'Vote down'

        within ".rating-count-#{question.id}" do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'vote up, then down (change vote)' do
      within '.question-info' do
        click_on 'Vote up'
        click_on 'Vote down'

        within ".rating-count-#{question.id}" do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'vote down, then up (change vote)' do
      within '.question-info' do
        click_on 'Vote down'
        click_on 'Vote up'

        within ".rating-count-#{question.id}" do
          expect(page).to have_content '1'
        end
      end
    end
  end

  scenario 'Author of question vote for their question', js: true do
    sign_in author
    visit question_path(question)

    within '.question-info' do
      expect(page).to_not have_link('Vote up')
      expect(page).to_not have_link('Vote down')
    end
  end
end
