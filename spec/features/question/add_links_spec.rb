# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/killkih/31cac7ae2aee63f88e23de9d256eef6d' }
  given(:question) { create(:question, user: user) }

  describe 'User add link when asks question' do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      fill_in 'Link name', with: 'My gist'
      fill_in 'URL', with: gist_url
    end

    scenario 'with valid attributes' do
      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'with invalid url' do
      fill_in 'URL', with: 'test'
      click_on 'Ask'

      expect(page).to have_content 'Links url must be a valid URL'
    end
  end

  scenario 'Update question with link', js: true do
    sign_in user
    visit question_path(question)

    within '.question' do
      click_on 'Edit'
      click_on 'Add link'
      fill_in 'Link name', with: 'test'
      fill_in 'URL', with: gist_url
      click_on 'Save'

      expect(page).to have_link 'test', href: gist_url
    end
  end
end
