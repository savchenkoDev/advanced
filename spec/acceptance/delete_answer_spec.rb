require 'rails_helper.rb'

feature 'Delete answer', %q{
  In order to delete a question
  as an user
  I should be its author
} do
  given!(:user) { create(:user) }
  given!(:question) { user.questions.create!(title: 'Title Question', body: 'Question Body') }
  given!(:answer) { question.answers.create!(body: 'Answer Body', user: user) }
  
  scenario 'The author wants to delete the your answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'
    
    expect(page).to_not have_content answer.body
  end

  scenario 'Non author wants to delete the answer' do
    non_author = create(:user)
    sign_in(non_author)
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Un-authenticated user wants to delete the answer' do
    visit question_path(question)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end