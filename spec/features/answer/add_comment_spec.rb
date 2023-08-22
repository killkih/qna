# frozen_string_literal: true

require 'rails_helper'

feature 'Authenticated user can comment the answer', "
  In order to add helpful info for answer
  As an authenticated user
  I'd like to be able to add comment
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  context 'authenticated user', js: true do
    scenario 'add comment' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        fill_in 'Comment', with: 'text text text'
        click_on 'Send'

        expect(page).to have_content 'text text text'
      end
    end
  end

  context 'multiply sessions' do
    scenario "comments appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do
          fill_in 'Comment', with: 'text text text'
          click_on 'Send'
        end

        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text text'
      end
    end
  end

  scenario 'unauthenticated user' do
    visit question_path(question)

    expect(page).to_not have_link 'Send'
  end
end
