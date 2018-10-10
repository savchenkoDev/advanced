require_relative 'acceptance_helper'

feature 'Add files to entity', %q{
  In order to illustrate
  As an entity's author
  i'd like to be able to attach files
} do
  given!(:user) { create(:user) }
  given(:question) { create(:question) }

  background { sign_in(user) }

  describe 'User adds file' do
    scenario 'to question', js: true do
      visit new_question_path()
      fill_in 'Title' , with: 'Test Question'
      fill_in 'Body' , with: 'Test Body'
      attach_file 'File', "#{Rails.root}/.ruby-version"
      click_on 'Add file'
      all('input[type="file"]').last.set "#{Rails.root}/.ruby-gemset"
      click_on 'Create'
      expect(page).to have_link '.ruby-version', href: /(\/uploads\/attachment\/file\/)(\d+)(\/.ruby-version)/
      expect(page).to have_link '.ruby-gemset', href: /(\/uploads\/attachment\/file\/)(\d+)(\/.ruby-gemset)/
    end
  
    scenario 'to answer', js: true do
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
  end

  describe 'User can cancel adding file' do
    scenario 'for question', js: true do
      visit new_question_path()
      fill_in 'Title' , with: 'Test Question'
      fill_in 'Body' , with: 'Test Body'
      click_on 'remove'
      expect(page).to_not have_content find('input[type="file"]')
    end

    scenario 'for answer', js: true do
      visit question_path(question)
      fill_in 'Your answer' , with: 'Answer body'
      click_on 'remove'
      expect(page).to_not have_content find('input[type="file"]')
    end
  end
  
end