# frozen_string_literal: true

require 'rails_helper'

feature 'User can unsubscribe on question', "
  In order to not get notice with answer
  As an authenticated user
  I'd like to be able to unsubscribe
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:subscription) { create(:subscription, question: question, user: user) }

  describe 'Authenticated user', js: true do
    scenario 'user subscribes' do
      sign_in(user)

      visit question_path(question)
      click_on 'Unsubscribe'

      expect(page).to have_button 'Subscribe'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not subscribe' do
      visit question_path(question)

      expect(page).to_not have_button 'Unsubscribe'
    end
  end
end
