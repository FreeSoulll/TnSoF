require 'rails_helper'

feature 'User can register', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to register
} do

  background { visit new_user_registration_path }

  scenario 'User tries to register' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
  end
end
