require_relative 'acceptance_helper'

feature 'User creates an answer', %q{
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
    scenario "question appears on another user's page" do
      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
        click_on 'Ask question'

        fill_in 'Body' , with: 'Answer Body'
        click_on 'Create'

        expect(page).to have_content 'Answer Body'
      end

      Capybara.using_session('guest') do
        save_and_open_page
        expect(page).to have_content 'Answer Body'
      end
    end
  end
end