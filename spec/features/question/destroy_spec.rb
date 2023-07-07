require 'rails_helper'

feature 'Author can destroy his question', %q{
  In order not to clutter up the list
  As an author
  I'd like to be able to destroy my question
} do

  given(:first_user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: first_user) }


  scenario 'Author tries to destroy his question' do
    sign_in(first_user)

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question successfully deleted!'
  end
  scenario "User tries to destroy someone else's question" do
    sign_in(second_user)

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Only the author can delete a question!'
  end
end
