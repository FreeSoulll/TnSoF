require 'rails_helper'

feature 'Authenticated user can vote for the answer', %q{
  In order to like or dislike answer
  As authenticated user and not author of answer
  I'd like to be able to vote for the answer
} do
  given!(:author)    { create(:user) }
  given!(:user)      { create(:user) }
  given!(:question)  { create(:question, user: author) }
  given!(:answer)    { create(:answer, question: question, user: author) }
  describe 'Authenticated user and not author of answer', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'vote up per answer' do
      within ".answer-#{answer.id}" do
        click_on 'Vote up'

        within ".rating-count-#{answer.id}" do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'vote up twice per answer (cancel vote)' do
      within ".answer-#{answer.id}" do
        click_on 'Vote up'
        click_on 'Vote up'

        within ".rating-count-#{answer.id}" do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'vote down per answer' do
      within ".answer-#{answer.id}" do
        click_on 'Vote down'

        within ".rating-count-#{answer.id}" do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'vote down twice per answer (cancel vote)' do
      within ".answer-#{answer.id}" do
        click_on 'Vote down'
        click_on 'Vote down'

        within ".rating-count-#{answer.id}" do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'vote up, then down (change vote)' do
      within ".answer-#{answer.id}" do
        click_on 'Vote up'
        click_on 'Vote down'

        within ".rating-count-#{answer.id}" do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'vote down, then up (change vote)' do
      within ".answer-#{answer.id}" do
        click_on 'Vote down'
        click_on 'Vote up'

        within ".rating-count-#{answer.id}" do
          expect(page).to have_content '1'
        end
      end
    end
  end

  scenario 'Author of answer vote for their answer', js: true do
    sign_in author
    visit question_path(question)

    within ".answer-#{answer.id}" do
      expect(page).to_not have_link('Vote up')
      expect(page).to_not have_link('Vote down')
    end
  end
end
