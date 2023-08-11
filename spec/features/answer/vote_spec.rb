require 'rails_helper'

feature 'User can upvote an answer', %q{
  In order to mark the helpful answer
  As an user
  I'd like to be able to upvote the answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

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

    scenario 'User can upvote the answer' do
      within '.answers' do
        click_on '+'

        expect(page).to_not have_link '+'
        expect(page).to have_link 'Cancel vote'
      end
    end
  end
end
