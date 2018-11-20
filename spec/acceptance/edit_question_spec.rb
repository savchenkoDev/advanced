require_relative 'acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of question
  Id like to be able to edit my question
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
 
  scenario "Un-authenticated user want to edit question" do
    visit question_path(question)
    expect(page).to_not have_link 'Edit question'
  end

  describe "User as an author" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "sees link to edit" do
      expect(page).to have_link 'Edit question'
    end

    scenario 'try to edit his question', js: true do
      click_on 'Edit question'
      within '.question' do
        fill_in "New title",	with: "New question title"
        fill_in "New body",	with: "New question body"
        click_on 'Save'
        expect(page).to_not have_content question.body
        expect(page).to have_content "New question title"
        expect(page).to have_content "New question body"
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  scenario "Non author can't sees link to edit" do
    sign_in(user2)
    visit question_path(question)
    expect(page).to_not have_link 'Edit question'
  end
end