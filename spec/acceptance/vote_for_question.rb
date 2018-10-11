require_relative 'acceptance_helper.rb'

feature 'Voting for the question', %q{
  In order to
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }


  describe "Authenticated user" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'want to votes for the question' do
      click_on 'Like'
      within '.rating' do
        expect(page).to have_content "1"
      end
    end
  end
end 