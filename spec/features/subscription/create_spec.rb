# frozen_string_literal: true

require 'rails_helper'

feature 'User can subscribe on question', "
  In order to get notice with answer
  As an authenticated user
  I'd like to be able to receive notice
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    scenario 'user subscribes' do
      sign_in(user)

      visit question_path(question)
      click_on 'Subscribe'

      expect(page).to have_button 'Unsubscribe'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not subscribe' do
      visit question_path(question)

      expect(page).to_not have_button 'Subscribe'
    end
  end
end
