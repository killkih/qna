# frozen_string_literal: true

require 'rails_helper'

feature 'User can view the list of questions', "
  In order to select question
  As an authenticated user
  I'd like to view a list of questions
" do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5) }

  scenario 'Authenticated user views the list of questions' do
    sign_in(user)

    visit questions_path

    expect(page).to have_content questions[1].title
  end

  scenario 'Unauthenticated user views the list of questions' do
    visit questions_path

    expect(page).to have_content questions[1].title
  end
end
