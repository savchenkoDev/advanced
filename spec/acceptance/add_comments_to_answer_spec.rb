require_relative 'acceptance_helper'

feature 'Add comments to answer', %q{
  In order to share opinion
  As an authnticated user
  i'd like to be able to add comments
} do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'As authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario '- add comment with valid attributes', js: true do
      within '.answer-comment-form' do
        fill_in 'Text',	with: 'Comment body' 
        click_on 'Save comment'
      end

      within ".answer-#{answer.id}-comments-list" do
        expect(page).to have_content 'Comment body'
      end
    end

    scenario '- add comment with invalid attributes', js: true do
      within '.answer-comment-form' do
        click_on 'Save comment'
      end

      within ".answer-#{answer.id}-comments-list" do
        expect(page).to_not have_selector "li"
      end
    end
  end

  describe 'As un-authenticated user' do
    scenario 'wants add comment', js: true do
      visit question_path(question)

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'multiple sessions' do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user2') do
        sign_in(user2)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        within '.answer-comment-form' do
          fill_in 'Text' , with: 'Test Comment'
          click_on 'Save comment'
        end
        expect(page).to have_content 'Test Comment'
      end

      Capybara.using_session('user2') do
        expect(page).to have_content 'Test Comment'
      end
    end
  end
end