require_relative 'acceptance_helper'

feature 'Show question with answers list', %q{
  In order to select a question
  as an authenticated user, 
  I want to see a list of questions
} do
  given(:user) { create(:user)}
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 7, question: question) }

  scenario 'Autheticated user wants to see a question with answers list' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.count.times { |i| expect(page).to have_content answers[i].body }
  end

end