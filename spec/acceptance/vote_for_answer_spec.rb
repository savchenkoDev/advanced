require_relative 'acceptance_helper'

feature 'Voting for the answer', %q{
  In order to support the author
  as an authenticated user
  i'd like to be able to vote for the answer
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }


  describe "Authenticated user" do
    background do
      sign_in(user)
    end

    describe 'wants to put your vote for answer' do
      before  { visit question_path(question) }

      scenario ' - "Like"', js: true do
        within ".answer-#{answer.id}-rating-buttons" do
          click_on 'Like'
        end
  
        within ".answer-#{answer.id}-rating" do
          expect(page).to have_content answer.rating
        end
        within ".answer-#{answer.id}-rating-buttons" do
          expect(page).to have_link 'Delete vote', href: /(\/answers\/)(\d+)(\/destroy_vote)/
          expect(page).to_not have_link 'Like'
          expect(page).to_not have_link 'Dislike'
        end
      end

      scenario ' - "Dislike"', js: true do
        within ".answer-#{answer.id}-rating-buttons" do
          click_on 'Dislike'
        end
  
        within ".answer-#{answer.id}-rating" do
          expect(page).to have_content answer.rating
        end
        within ".answer-#{answer.id}-rating-buttons" do
          expect(page).to have_link 'Delete vote', href: /(\/answers\/)(\d+)(\/destroy_vote)/
          expect(page).to_not have_link 'Like'
          expect(page).to_not have_link 'Dislike'
        end
      end
    end

    describe 'wants to remove your vote' do
      given!(:vote) { create(:vote, user: user, votable: answer) }

      before { visit question_path(question) }

      scenario ' - "Delete vote"', js: true do
        within ".answer-#{answer.id}-rating-buttons" do
          click_on 'Delete vote'
        end
        within ".answer-#{answer.id}-rating" do
          expect(page).to have_content answer.rating
        end
        within ".answer-#{answer.id}-rating-buttons" do
          expect(page).to_not have_link 'Delete vote'
          expect(page).to have_link 'Like', href: /(\/answers\/)(\d+)(\/like)/
          expect(page).to have_link 'Dislike', href: /(\/answers\/)(\d+)(\/dislike)/
        end
      end
    end
  end
end 