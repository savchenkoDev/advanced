require 'rails_helper.rb'

feature 'Delete answer', %q{
  In order to delete a question
  as an user
  I should be its author
} do

  scenario 'The author wants to delete the your answer' do
    user = create(:user)
    question = user.questions.create!(title: 'Title Question', body: 'Question Body')
    sign_in(user)
    question.answers.create!(body: 'Question Body', user_id: user.id)
    @count = question.answers.count
    visit answer_path(question.answers.last)
    click_on 'Delete'
    expect(user.answers.count).to eq @count - 1
    expect(current_path).to eq question_answers_path(question)
  end

  scenario 'Non author wants to delete the your answer' do
    user = create(:user)
    question = user.questions.create!(title: 'Title Question', body: 'Question Body')
    answer = question.answers.create!(body: 'Question Body', user_id: user.id)
    @count = question.answers.count
    user2 = create(:user)
    sign_in(user2)
    visit answer_path(answer)
    click_on 'Delete'
    expect(user.answers.count).to eq @count
    expect(current_path).to eq question_answers_path(question)
  end
end