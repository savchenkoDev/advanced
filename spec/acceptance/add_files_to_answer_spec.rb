require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In oreder to illustrate my answer
  As an answer's author
  i'd like to be able to attach files
} do
  given!(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file to answer', js: true do
    fill_in 'Your answer' , with: 'Answer body'
    attach_file 'File', "#{Rails.root}/Gemfile"
    click_on 'Create answer'
    
    within '.answers' do
      expect(page).to have_link 'Gemfile', href: '/uploads/attachment/file/1/Gemfile'
    end
  end
end