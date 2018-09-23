require 'rails_helper.rb'

feature 'Sign Up New User', %q{
  In order to be able to authorize in the application
  as a user
  I want to be able to register in the application
} do
  scenario 'Unregistered user wants to register' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end