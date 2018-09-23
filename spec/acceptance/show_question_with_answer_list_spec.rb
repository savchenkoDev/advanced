require 'rails_helper.rb'

feature 'Show question with answers list', %q{
  In order to select a question
  as an authenticated user, 
  I want to see a list of questions
} do
  given(:question) { create(:question) }
  
  given(:answers) { create_list(question.answers, 2) }
  scenario 'Any user wants to see a question with answers list' do
    visit question_path(question)

    expect(page).to have_content question.body
    expect(page).to have_content 'All answers'
  end

end