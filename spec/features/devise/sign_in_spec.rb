# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in', "
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
" do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  describe 'Oauth' do
    describe 'github' do
      given(:user) { create(:user, email: 'test@test.com') }

      scenario 'unregistered user tries to sign in' do
        mock_auth_hash(:github, 'test@test.com')
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      scenario 'registered user tries to sign in' do
        mock_auth_hash(:github, user.email)
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end
    end

    describe 'vkontakte' do
      background do
        mock_auth_hash(:vkontakte)
        click_on 'Sign in with Vkontakte'
      end

      scenario 'unregistered user tries to sign in' do
        clear_emails

        fill_in 'Email', with: 'test@test.com'
        click_on 'Send'

        open_email('test@test.com')
        current_email.click_on('Confirm my account')

        expect(page).to have_content 'Your email address has been successfully confirmed.'
      end

      scenario 'registered user tries to sign in' do
        create(:user, email: 'test@test.com')

        fill_in 'Email', with: 'test@test.com'
        click_on 'Send'

        expect(page).to have_content 'Email has already been taken'
      end

      scenario 'email is blank' do
        click_on 'Send'
        expect(page).to have_content "Email can't be blan"
      end

      scenario 'email is invalid' do
        fill_in 'Email', with: 'test'

        click_on 'Send'
        expect(page).to have_content 'Email is invalid'
      end
    end
  end
end
