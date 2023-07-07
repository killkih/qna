require 'rails_helper'

feature 'User can destroy his answer', %q{
  In order not to clutter up the list
  As an author of answer
  I'd like to be able to destroy my answer
} do

  given(:first_user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: first_user) }
  given!(:answer) { create(:answer, question: question, user: first_user) }

  scenario 'Author tries to destroy his answer' do
    sign_in(first_user)

    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content 'Answer successfully deleted!'
  end
  scenario "User tries to destroy someone else's answer" do
    sign_in(second_user)

    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content 'Only the author can delete a answer!'
  end
end
