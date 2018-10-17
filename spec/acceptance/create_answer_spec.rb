require_relative 'acceptance_helper'

feature 'User creates an answer', %q{
  In order to exchange my knowledge
  As an authenticated user
  I want to be able to create answer
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
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

  scenario 'User try to create invalid answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on "Create answer"
    
    expect(current_path).to eq question_path(question)
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Un-authenticated user create answer', js: true do
    visit question_path(question)
    
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end

  context 'multiple sessions' do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user2') do
        sign_in(user2)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        
        fill_in 'Your answer' , with: 'Answer Body'
        click_on 'Create answer'

        expect(page).to have_content 'Answer Body'
      end

      Capybara.using_session('user2') do

        expect(page).to have_content 'Answer Body'
      end
    end
  end
end