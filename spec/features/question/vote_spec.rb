# frozen_string_literal: true

require 'rails_helper'

feature 'User can upvote a question', "
  In order to mark the helpful question
  As an user
  I'd like to be able to upvote the question
" do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Unauthenticated user can not upvote' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
      expect(page).to_not have_link 'Cancel vote'
    end
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'User can like the question' do
      within '.question' do
        click_on '+'

        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to have_link 'Cancel vote'
        expect(page).to have_content "Rating:\n1"
      end
    end

    scenario 'User can dislike the question' do
      within '.question' do
        click_on '-'

        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to have_link 'Cancel vote'
        expect(page).to have_content "Rating:\n-1"
      end
    end

    scenario 'User can cancel vote the question' do
      within '.question' do
        click_on '+'
        click_on 'Cancel vote'

        expect(page).to have_link '+'
        expect(page).to have_link '-'
        expect(page).to_not have_link 'Cancel vote'
        expect(page).to have_content "Rating:\n0"
      end
    end
  end

  describe 'Author' do
    background do
      sign_in author
      visit question_path(question)
    end

    scenario 'Author can not upvote the question' do
      within '.question' do
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '+'
      end
    end

    scenario 'Author can not cancel vote' do
      within '.question' do
        expect(page).to_not have_link 'Cancel vote'
      end
    end
  end
end
