# frozen_string_literal: true

require 'rails_helper'

feature 'User can add answer to the question', "
  In order to give answer to the community
  As an authenticated user
  I'd like to be able to add answer to the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Add answer' do
      fill_in 'Your Answer', with: 'test test test'
      click_on 'Post Your Answer'

      expect(page).to have_content 'test test test'
    end

    scenario 'Add answer with invalid data' do
      click_on 'Post Your Answer'

      expect(page).to have_content "Body can't be blank"
    end

  end

  scenario 'Unauthenticated user tries to add answer' do
    visit question_path(question)

    fill_in 'Your Answer', with: 'test test test'
    click_on 'Post Your Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
