require_relative 'acceptance_helper'

feature 'Delete files from question', %q{
  In order to
} do
  given(:user) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  describe 'Author of question' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees "Delete" link' do
      expect(page).to have_link 'delete'
    end

    scenario 'can detach file from question', js: true do
      within ".attachment-#{attachment.id}" do
        click_on 'delete'
      end
      expect(page).to_not have_link attachment.file.identifier
    end
  end

  describe 'Non-author of question' do
    before do
      sign_in(non_author)
      visit question_path(question)
    end

    scenario "can't sees 'Delete' link" do
      expect(page).to_not have_link 'delete'
    end
  end
end