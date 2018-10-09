require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In oreder to illustrate my question
  As an question's author
  i'd like to be able to attach files
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path()
  end

  scenario 'User adds file to answer', js: true do
    fill_in 'Title' , with: 'Test Question'
    fill_in 'Body' , with: 'Test Body'
    attach_file 'File', "#{Rails.root}/.ruby-version"
    click_on 'Add file'
    all('input[type="file"]').last.set "#{Rails.root}/.ruby-gemset"
    click_on 'Create'
    expect(page).to have_link '.ruby-version', href: /(\/uploads\/attachment\/file\/)(\d+)(\/.ruby-version)/
    expect(page).to have_link '.ruby-gemset', href: /(\/uploads\/attachment\/file\/)(\d+)(\/.ruby-gemset)/
  end

  scenario 'user can remove files', js: true do
    fill_in 'Title' , with: 'Test Question'
    fill_in 'Body' , with: 'Test Body'
    click_on 'remove'
    expect(page).to_not have_content find('input[type="file"]')
  end
end