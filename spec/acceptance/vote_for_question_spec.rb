require_relative 'acceptance_helper'

feature 'Voting for the question', %q{
  In order to
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }


  describe "Authenticated user" do
    background do
      sign_in(user)
    end

    describe 'wants to put your vote for qestion' do
      before  { visit question_path(question) }

      scenario ' - "Like"', js: true do
        within ".question-#{question.id}-rating-buttons" do
          click_on 'Like'
        end
  
        within ".question-#{question.id}-rating" do
          expect(page).to have_content question.rating
        end
        within ".question-#{question.id}-rating-buttons" do
          expect(page).to have_link 'Delete vote', href: /(\/questions\/)(\d+)(\/destroy_vote)/
          expect(page).to_not have_link 'Like'
          expect(page).to_not have_link 'Dislike'
        end
      end

      scenario ' - "Dislike"', js: true do
        within ".question-#{question.id}-rating-buttons" do
          click_on 'Dislike'
        end
  
        within ".question-#{question.id}-rating" do
          expect(page).to have_content question.rating
        end
        within ".question-#{question.id}-rating-buttons" do
          expect(page).to have_link 'Delete vote', href: /(\/questions\/)(\d+)(\/destroy_vote)/
          expect(page).to_not have_link 'Like'
          expect(page).to_not have_link 'Dislike'
        end
      end
    end

    describe 'wants to remove your vote' do
      given!(:vote) { create(:vote, user: user, votable: question) }

      before { visit question_path(question) }

      scenario ' - "Delete vote"', js: true do
        within ".question-#{question.id}-rating-buttons" do
          click_on 'Delete vote'
        end
        within ".question-#{question.id}-rating" do
          expect(page).to have_content question.rating
        end
        within ".question-#{question.id}-rating-buttons" do
          expect(page).to_not have_link 'Delete vote'
          expect(page).to have_link 'Like', href: /(\/questions\/)(\d+)(\/like)/
          expect(page).to have_link 'Dislike', href: /(\/questions\/)(\d+)(\/dislike)/
        end
      end
    end
  end
  # given(:user) { create(:user) }
  # given(:author) { create(:user) }
  # given!(:question) { create(:question, user: author) }


  # describe "Authenticated user" do
  #   background do
  #     sign_in(user)
  #     visit question_path(question)
  #   end

  #   scenario "wants to vote for the question", js: true do
  #     within '.question-rating' do
  #       click_on 'Like'
  #     end

  #     expect(page).to have_content question.rating
  #     expect(page).to have_link 'Delete vote', href: /(\/questions\/)(\d+)(\/destroy_vote)/
  #     expect(page).to_not have_link 'Like'
  #     expect(page).to_not have_link 'Dislike'
  #   end
  # end
end 