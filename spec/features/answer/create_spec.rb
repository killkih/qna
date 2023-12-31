# frozen_string_literal: true

require 'rails_helper'

feature 'User can add answer to the question', "
  In order to give answer to the community
  As an authenticated user
  I'd like to be able to add answer to the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Add answer' do
      fill_in 'Your Answer', with: 'test test test'
      click_on 'Post Your Answer'

      expect(page).to have_content 'test test test'
    end

    scenario 'Add answer with invalid data' do
      click_on 'Post Your Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'Add answer with attached file' do
      fill_in 'Your Answer', with: 'test test test'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Post Your Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'multiple sessions' do
    scenario "answers appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your Answer', with: 'test test test'
        click_on 'Post Your Answer'

        expect(page).to have_content 'test test test'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'test test test'
      end
    end
  end

  scenario 'Unauthenticated user tries to add answer' do
    visit question_path(question)

    fill_in 'Your Answer', with: 'test test test'
    click_on 'Post Your Answer'

    expect(page).to have_content 'You are not authorized to access this page.'
  end
end
