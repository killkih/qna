require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/killkih/31cac7ae2aee63f88e23de9d256eef6d' }

  scenario 'User add link when give an answer', js: true do
    sign_in user
    visit question_path(question)

    fill_in 'Your Answer', with: 'My answer'
    fill_in 'Link name', with: 'My gist'
    fill_in 'URL', with: gist_url
    click_on 'Post Your Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
