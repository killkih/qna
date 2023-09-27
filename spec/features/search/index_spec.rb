# frozen_string_literal: true

require 'rails_helper'

feature 'User can search', "
  In order to get resources he needs
  As an user
  I'd like to be able to use search
" do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:question_comment) { create(:comment, commentable: question, body: 'Question Comment') }
  given!(:answer_comment) { create(:comment, commentable: answer, body: 'Answer Comment') }

  background { visit root_path }

  scenario 'search by All' do
    select 'All', from: :resource
    fill_in 'Search', with: question.title
    click_on 'Search'

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'search by Question' do
    select 'Question', from: :resource
    fill_in 'Search', with: question.title
    click_on 'Search'

    expect(page).to have_link question.title
    expect(page).to have_content question.body
  end

  scenario 'search by Answer' do
    select 'Answer', from: :resource
    fill_in 'Search', with: answer.body
    click_on 'Search'

    expect(page).to have_link answer.question.title
    expect(page).to have_content answer.body
  end

  scenario 'search by Question comment' do
    select 'Comment', from: :resource
    fill_in 'Search', with: question_comment.body
    click_on 'Search'

    expect(page).to have_link question_comment.commentable.title
    expect(page).to have_content question_comment.body
  end

  scenario 'search by Answer comment' do
    select 'Comment', from: :resource
    fill_in 'Search', with: answer_comment.body
    click_on 'Search'

    expect(page).to have_link answer_comment.commentable.question.title
    expect(page).to have_content answer_comment.commentable.body
    expect(page).to have_content answer_comment.body
  end

end