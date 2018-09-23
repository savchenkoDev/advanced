require 'rails_helper.rb'

feature 'Show questions list', %q{
  In order to select a question
  as an authenticated user, 
  I want to see a list of questions
} do
  scenario 'User wants to see a list of questions' do
    visit questions_path
    expect(page).to have_content 'All questions'
  end

end