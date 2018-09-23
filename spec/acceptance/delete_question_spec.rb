require 'rails_helper.rb'

feature 'Delete question', %q{
  In order to delete a question
  as an user
  I should be its author
} do
  scenario 'The author wants to delete the your question' do
    user = create(:user)
    @count = user.questions.count
    sign_in(user)
    question = user.questions.create!(title: 'Test Question', body: 'Question Body')
    visit question_path(question)
    click_on 'Delete'
    expect(user.questions.count).to eq @count
    expect(current_path).to eq questions_path
  end


  scenario 'Not author wants to delete the question' do
    users = create_list(:user, 2)
    @count = users[0].questions.count

    sign_in(users[0])
    question = users[0].questions.create!(title: 'Test Question', body: 'Question Body')
    click_on 'Log out'
    sign_in(users[1])
    visit question_path(question)
    click_on 'Delete'
    expect(users[0].questions.count).to eq @count + 1
    expect(current_path).to eq questions_path
  end
end