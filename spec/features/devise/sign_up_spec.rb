# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign up', "
  In order to ask the question or add an answer
  As an unauthenticated user
  I'd like to be able to sign up
" do
  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up' do
    clear_emails

    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    open_email('test@test.com')
    current_email.click_on 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  scenario 'Unregistered user tries to sign up with invalid data' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: nil
    fill_in 'Password confirmation', with: nil
    click_on 'Sign up'

    expect(page).to have_content "Password can't be blank"
  end
end
