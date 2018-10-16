require_relative 'acceptance_helper'

feature 'Add comments to question', %q{
  In order to share opinion
  As an authnticated user
  i'd like to be able to add comments
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'As authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario '- add comment with valid attributes', js: true do
      fill_in "Text",	with: 'Comment body' 
      click_on 'Save comment'

      expect(page).to have_content 'Comment body'
    end

    scenario '- add comment with invalid attributes', js: true do
      click_on 'Save comment'

      expect(page).to_not have_content 'Comment body'
      expect(page).to have_content "Text can't be blank"
    end
  end

  describe 'As un-authenticated user' do
    scenario 'wants add comment', js: true do
      visit question_path(question)

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end