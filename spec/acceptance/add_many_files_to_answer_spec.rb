require_relative 'acceptance_helper'

feature 'Add many files to answer', %q{
  In oreder to illustrate my answer
  As an answer's author
  i'd like to be able to attach many files
} do
  given!(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file to answer', js: true do
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

  scenario 'user can remove files', js: true do
    fill_in 'Your answer' , with: 'Answer body'
    click_on 'remove'
    expect(page).to_not have_content find('input[type="file"]')
  end
end