# frozen_string_literal: true

require 'rails_helper'

feature 'The user can view the question and its answers', "
  In order to get information from the community
  As authenticated or unauthenticated user
  I'd like to see the question and the answers to it
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'Authenticated user views the question' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content answers[1].body
  end

  scenario 'Unauthenticated user views the question' do
    visit question_path(question)

    expect(page).to have_content answers[1].body
  end
end
