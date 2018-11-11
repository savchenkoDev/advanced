require_relative 'acceptance_helper'

feature 'Subscription to question', %q{
  In order to follow the changes in the question
  as an authenticated user,
  I want to be able to subscribe to the question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthenticate user want create subscription', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Subscribe'
  end

  scenario 'Authenticate user want create subscription', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Subscribe'
    expect(page).to have_link 'Unsubscribe'
    click_on 'Unsubscribe'
    expect(page).to have_link 'Subscribe'  
  end
  
    
end