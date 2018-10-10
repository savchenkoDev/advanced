require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate answer
  As an entity's author
  i'd like to be able to attach files
} do
  given!(:user) { create(:user) }
  given(:question) { create(:question) }

  background { sign_in(user) }

  scenario 'User adds file to answer', js: true do
      visit question_path(question)
      fill_in 'Your answer' , with: 'Answer body'
      attach_file 'File', "#{Rails.root}/.ruby-version"
      click_on 'Add file'
      all('input[type="file"]')[1].set "#{Rails.root}/.ruby-gemset"
      click_on 'Create answer'
      
      within '.answer' do
        expect(page).to have_link '.ruby-version', href: /(\/uploads\/attachment\/file\/)(\d+)(\/.ruby-version)/
        expect(page).to have_link '.ruby-gemset', href: /(\/uploads\/attachment\/file\/)(\d+)(\/.ruby-gemset)/
      end
    end

  scenario 'User can cancel adding file', js: true do
    visit question_path(question)
    fill_in 'Your answer' , with: 'Answer body'
    click_on 'remove'
    expect(page).to_not have_content find('input[type="file"]')
  end
  
end