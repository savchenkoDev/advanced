require_relative 'acceptance_helper'

feature 'Authorization with Facebook', %q{
  In order to work with Questions and Answers
  As an authenticated user
  I want to authorization with social networks accounts
} do

  describe 'Facebook' do
    let(:user) { create(:user) }
    
    scenario '- user want authorization with Facebook', js: true do
      auth = mock_auth_hash(:facebook)
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit user_session_path
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Successfully authenticated from Facebook account.'  
    end
  end

  describe 'Vkontakte' do
    let(:user) { create(:user, email: 'new_user@email.com') }
    
    describe 'User wants authenticated first time' do
      scenario '- with valid email', js: true do
        visit new_user_session_path
        click_on 'Sign in with Vkontakte'
        
        expect(page).to have_content 'Change your email'
        
        fill_in 'Email', with: 'user@test.com'
        click_on 'Save email'
        
        expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
      end

      scenario '- with invalid email', js: true do
        visit new_user_session_path
        click_on 'Sign in with Vkontakte'
        
        expect(page).to have_content 'Change your email'
        
        click_on 'Save email'
        
        expect(page).to have_content "Email can't be blank"
      end
    end
    
    scenario 'User already have auhorization' do

      auth = mock_auth_hash(:vkontakte)
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)

      visit user_session_path
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'  
    end
  end
end
