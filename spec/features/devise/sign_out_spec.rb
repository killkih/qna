# frozen_string_literal: true

require 'rails_helper'

feature 'User can log out', "
  In order to end the session
  As an authenticated user
  I'd like to be able to log out
" do
  given(:user) { create(:user) }

  scenario 'Registered user tries to log out' do
    sign_in(user)

    visit root_path
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
