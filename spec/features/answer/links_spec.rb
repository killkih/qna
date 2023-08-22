# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/killkih/31cac7ae2aee63f88e23de9d256eef6d' }
  given(:link) { create(:link, linkable: answer) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'User add link when give an answer' do
    background do
      sign_in user
      visit question_path(question)

      fill_in 'Your Answer', with: 'My answer'
      fill_in 'Link name', with: 'My gist'
      fill_in 'URL', with: gist_url
    end

    scenario 'with valid attributes', js: true do
      click_on 'Post Your Answer'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end
    end

    scenario 'with invalid url', js: true do
      fill_in 'URL', with: 'test'
      click_on 'Post Your Answer'

      expect(page).to have_content 'Links url must be a valid URL'
    end
  end

  scenario 'Update answer with link', js: true do
    sign_in user
    visit question_path(question)

    within '.answers' do
      click_on 'Edit'
      click_on 'Add link'
      fill_in 'Link name', with: 'test'
      fill_in 'URL', with: gist_url
      click_on 'Save'

      expect(page).to have_link 'test', href: gist_url
    end
  end

  scenario 'Delete answer link', js: true do
    link
    sign_in user
    visit question_path(question)

    within '.answers' do
      click_on 'Edit'
      click_on 'Remove link'
      click_on 'Save'
      expect(page).to_not have_link link.name, href: link.url
    end
  end
end
