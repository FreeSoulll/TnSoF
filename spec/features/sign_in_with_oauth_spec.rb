require 'rails_helper'

feature 'User can sign in with oauth', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do
  background { visit new_user_session_path }

  scenario 'Signin with provider with email' do
    mock_auth_hash('test@mail.ru')
    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Successfully authenticated from Github account.'
  end

  scenario 'Signin with provider witout email' do
    mock_auth_hash
    click_on 'Sign in with GitHub'

    fill_in 'user_email', with: 'test@mail.ru'
    click_on 'Confirm'

    open_email('test@mail.ru')

    expect(current_email).to have_content 'Confirm my account'
  end
end
