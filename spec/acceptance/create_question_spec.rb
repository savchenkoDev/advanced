require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  as an athenticated user
  i want to be able to ask question
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title' , with: 'Test Question'
    fill_in 'Body' , with: 'Test Body'
    click_on 'Create'
    
    expect(page).to have_content 'Test Question'
    expect(page).to have_content 'Test Body'
    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Non-authenticated user creates question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user creates a invalid question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    click_on 'Create'

    expect(page).to have_content '4 errors'
    expect(page).to have_content "Title can't be blank"
  end

end