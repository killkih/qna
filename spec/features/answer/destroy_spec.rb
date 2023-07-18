# frozen_string_literal: true

require 'rails_helper'

feature 'User can destroy his answer', "
  In order not to clutter up the list
  As an author of answer
  I'd like to be able to destroy my answer
" do
  given(:first_user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: first_user) }
  given!(:answer) { create(:answer, question: question, user: first_user) }

  describe 'Authenticated user', js: true do
    scenario 'Author tries to destroy his answer' do
      sign_in(first_user)

      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to_not have_content answer.body
    end

    scenario "User tries to destroy someone else's answer" do
      sign_in(second_user)

      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenricated user tries to destroy answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
