require_relative 'acceptance_helper'

feature 'Subscription to question', %q{
  In order to follow the changes in the question
  as an authenticated user,
  I want to be able to subscribe to the question
} do
  given!(:user) { create(:user) }
  given!(:other) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Create subscription' do
    scenario 'Unauthenticate user want create subscription', js: true do
      visit question_path(question)
      expect(page).to_not have_link 'Subscribe'
    end
  
    scenario 'Authenticate user want create subscription', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end
  end
  
  describe 'Delete subscription' do
    scenario 'Unauthenticate user want delete subscription', js: true do
      visit question_path(question)
      expect(page).to_not have_link 'Subscribe'
    end
  
    describe 'Authenticate user' do
      given!(:user_subscription) { create(:subscription, user: user, question: question) }
      given(:question_no_subs) { create(:question) }
      given!(:other_subscription) { create(:subscription, user: other, question: question_no_subs) }
      
      scenario 'as subscription author', js: true do
        sign_in(user)
        visit question_path(question)
        click_on 'Unsubscribe'
        expect(page).to have_link 'Subscribe'
      end

      scenario 'as does not subscription author', js: true do
        sign_in(user)
        visit question_path(question_no_subs)
        save_and_open_page
        expect(page).to_not have_link 'Unsubscribe'
      end
    end
  end
  
    
end