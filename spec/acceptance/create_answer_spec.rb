require 'rails_helper.rb'

feature 'User answer AJAX', %q{
  In order to exchange my knowledge
  As an authenticated user
  I want to be able to create answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates an valid answer', js: true do
    body = 'Test Answer Body'
    sign_in(user)
    visit question_path(question)
    fill_in 'Your answer', with: body
    click_on "Create answer"
    
    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content body
    end
  end

  scenario 'Authenticated user create invalid answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on "Create answer"
    
    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content "My Answer body"
  end

  scenario 'Un-authenticated user create answer', js: true do
    visit question_path(question)
    
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end