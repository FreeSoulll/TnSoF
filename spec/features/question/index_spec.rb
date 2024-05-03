require 'rails_helper'

feature 'User can index', %q{
  The ability to view questions and answers
  To any user
} do
  given!(:questions) { create_list(:question, 3, title: 'TestTitle') }

  scenario 'view list a questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content(question.title)
    end
  end

  describe 'Question answers' do
    given!(:answers) { create_list(:answer, 3, question: questions.first) }

    scenario 'view question answers' do
      visit question_path(questions.first.id)

      answers.each do |answer|
        expect(page).to have_content(answer.body)
      end
    end
  end
end
