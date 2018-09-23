require 'rails_helper.rb'

feature 'Show inline form on question page', %q{
  To answer the question
  as an authenticated user,
  I want to see the form on the question page
} do 
  given(:user) { create(:user) }
  let(:question) { create(:question) }

  scenario 'Any user wants to create an answer' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body' , with: 'Answer'
    click_on 'Create Answer'
    
    expect(current_path).to eq question_path(question)
  end
end