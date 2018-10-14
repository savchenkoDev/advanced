require 'rails_helper.rb'

RSpec.describe User do
  let!(:user) { create(:user) }
  let!(:user_question) { create(:question, user: user) }
  let!(:question) { create(:question) }
  let!(:vote) { create(:vote, user: user, votable: question) }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    it 'is author of entity' do
      expect(user).to be_author_of(user_question)
    end
  
    it 'is not author of entity' do
      expect(user).to_not be_author_of(question)
    end    
  end
  
  describe '#voted?' do
    it 'have a vote for entity' do
      expect(user).to be_voted(question)
    end
  
    it 'does not have a vote for entity' do
      expect(user).to_not be_voted(user_question)
    end
  end

  describe '#vote' do
    it 'find Vote instance' do
      expect(user.vote(question)).to be_a(Vote)
    end
  end
  
end