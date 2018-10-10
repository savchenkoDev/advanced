require_relative 'acceptance_helper'

feature 'Delete files from entity', %q{
  In order to non illustrate
  as an entity's author
  I'd like to be able to detach files
} do
  given(:user) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user) }
  given!(:question_attachment) { create(:attachment, attachable: question) }
  given!(:answer_attachment) { create(:attachment, attachable: answer) }

  describe 'Author of entity' do
    before { sign_in(user) }
    
    scenario 'can detach file from question', js: true do
      visit question_path(question)
      within ".attachment-#{question_attachment.id}" do
        click_on 'delete'
      end
      expect(page).to_not have_link question_attachment.file.identifier
    end

    scenario 'can detach file from answer', js: true do
      visit question_path(answer.question)
      within ".attachment-#{answer_attachment.id}" do
        click_on 'delete'
      end
      expect(page).to_not have_link answer_attachment.file.identifier
    end
  end

  scenario "Non-author of entity can't sees 'Delete' link" do
    sign_in(non_author)
    visit question_path(answer.question)
    expect(page).to_not have_link 'delete'
  end
end