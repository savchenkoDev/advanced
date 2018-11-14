require_relative 'acceptance_helper'

feature 'Delete question', %q{
  In order to delete a question
  as an user
  I should be its author
} do
  given!(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Unauthenticate user want to delete the question' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete question'
  end

  describe 'Authenticate user' do
    scenario 'The author wants to delete the your question' do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete'
  
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(current_path).to eq questions_path
    end
  
    scenario 'Not author wants to delete the question' do
      non_author = create(:user)
      sign_in(non_author)
      visit question_path(question)
      
      expect(page).to_not have_content 'Delete question'
    end
  end
end