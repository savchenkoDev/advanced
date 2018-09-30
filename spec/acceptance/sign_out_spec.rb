require_relative 'acceptance_helper'

feature 'User sign out', %q{
  In order to exit the application 
  as an authorized user,
  I want to be able to sign out
} do
  given(:user) { create(:user) }

  scenario 'Authintacated user try to sign out' do
    sign_in(user)

    # expect(page).to have_content 'Log out'
    click_on 'Log out'
    
    expect(current_path).to eq root_path
    expect(page).to have_content 'Signed out successfully.'
  end
end