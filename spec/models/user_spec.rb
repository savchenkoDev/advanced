require 'rails_helper.rb'

RSpec.describe User do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers) }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'is author of entity' do
    user = create(:user)
    question = create(:question, user: user)
    expect(user.author_of?(question)).to be true
  end

  it 'is not author of entity' do
    user = create(:user)
    question = create(:question)
    expect(user.author_of?(question)).to be false
  end
end