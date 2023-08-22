# frozen_string_literal: true

require 'rails_helper'

feature 'User can upvote an answer', "
  In order to mark the helpful answer
  As an user
  I'd like to be able to upvote the answer
" do
  given!(:author) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Unauthenticated user can not upvote' do
    visit question_path(question)

    within '.answers' do
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

    scenario 'User can like the answer' do
      within '.answers' do
        click_on '+'

        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to have_link 'Cancel vote'
        expect(page).to have_content "Rating:\n1"
      end
    end

    scenario 'User can dislike the answer' do
      within '.answers' do
        click_on '-'

        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to have_link 'Cancel vote'
        expect(page).to have_content "Rating:\n-1"
      end
    end

    scenario 'User can cancel vote the answer' do
      within '.answers' do
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

    scenario 'Author can not upvote the answer' do
      within '.answers' do
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '+'
      end
    end

    scenario 'Author can not cancel vote' do
      within '.answers' do
        expect(page).to_not have_link 'Cancel vote'
      end
    end
  end
end
