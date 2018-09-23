require 'rails_helper.rb'

feature 'Create answer', %q{
  In order to get answer from community
  as an athenticated user
  i want to be able to ask question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates answer' do
    sign_in(user)
    visit new_question_answer_path(question)
    fill_in 'Body' , with: 'Answer Body'
    click_on 'Create answer'
    expect(page).to have_content 'Your answer successfully created.'
  end

  scenario 'Un-authenticated user creates answer' do
    visit new_question_answer_path(question)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end 