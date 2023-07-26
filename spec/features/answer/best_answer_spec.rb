# frozen_string_literal: true

require 'rails_helper'

feature 'Author of question can choose the best answer', "
  In order to mark the most helpful answer
  As an author of question
  I'd like to be able to choose the best answer
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: other_user, body: 'answer1') }

  describe 'Author of question', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'can choose the best answer' do
      click_on 'Best'

      expect(page).to have_content 'Best answer:'
    end

    scenario 'can choose other answer as the best' do
      create(:answer, question: question, user: other_user, best: true, body: 'answer2')

      click_on 'Best'

      expect(page).to have_content "Best answer:\n#{answer.body}"
    end
  end

  scenario 'Other user can not choose the best answer' do
    sign_in other_user
    visit question_path(question)

    expect(page).to_not have_link 'Best'
  end

  scenario 'Unautheticated user can not choose the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best'
  end
end
