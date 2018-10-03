require_relative 'acceptance_helper'

feature 'Choose best answer', %q{
  In order to
  as an author
  i want to be able to choose best answer
} do
  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  describe 'Authenticated user as' do
    describe "author" do
      before do
        sign_in(author)
        visit question_path(question)
      end
  
      scenario "sees 'Choose the best' link" do
        expect(page).to have_link "Choose the best"
      end

      scenario 'want to choose the best answer', js: true do
        within '.answer:last-child' do
          click_on 'Choose the best'
        end
        within '.answer:first-child' do
          expect(page).to have_content answers.last.body
        end
      end
    end

    scenario "non author can't sees 'Choose the best' link" do
      sign_in(non_author)
      visit question_path(question)
      expect(page).to_not have_link "Choose the best"
    end
  end

  scenario 'Un-authenticated user want to choose the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Choose the best'
  end
end