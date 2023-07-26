# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
" do
  given!(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his question' do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.question' do
        fill_in 'Your question', with: 'edited question'
        fill_in 'Body', with: 'test test test test'
        click_on 'Save'

        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content 'edited question'
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'input'
      end
    end

    scenario 'edits his question with errors' do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.question' do
        fill_in 'Your question', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Title can't be blank"
    end

    scenario "tries to edit other user's question" do
      sign_in other_user
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end

    scenario 'edit question with files' do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.question' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end
end
