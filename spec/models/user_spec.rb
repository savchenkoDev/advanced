require 'rails_helper.rb'

RSpec.describe User do
  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers) }
    it { should have_many(:votes) }
    it { should have_many(:comments) }
    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_many(:subscribed_question).through(:subscriptions) } 
  end
  
  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end
  
  describe "instance methods" do
    let(:user) { create(:user) }
    let(:user_with_temp_email) { create(:user, email: '123123_temp@temp.com') }
    let!(:user_question) { create(:question, user: user) }
    let!(:question) { create(:question) }
    let!(:vote) { create(:vote, user: user, votable: question) }
  
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
  
    describe '#temp_email' do
      it '- user have temp email' do
        expect(user_with_temp_email.temp_email?).to be_truthy
      end
  
      it "- user havn't temp email" do
        expect(user.temp_email?).to be_falsey
      end
    end

    describe "#subscribe?" do
      let(:subscription) { create(:subscription, user: user, question: question) }

      it 'be falsey if user does not have subscription to question' do
        expect(user).to_not be_subscribe(question)
      end
  
      it 'be truthy if user have subscription to question' do
        subscription
        expect(user).to be_subscribe(question)
      end
    end
  end
  describe "class methods" do
    describe '.find_for_oauth' do
      let!(:user) { create(:user) }
      
      context 'Facebook' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123') }
    
        context 'user already has authorization' do
          it '- returns the user' do
            user.authorizations.create(provider: 'facebook', uid: '123123')
            expect(User.find_for_oauth(auth)).to eq user
          end
        end
    
        context 'user has not authorization' do
          context 'user already exists' do
            let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123', info: { email: user.email }) }
    
            it '- does not create new user' do
              expect { User.find_for_oauth(auth) }.to_not change(User, :count)
            end
    
            it '- creates authorization for user' do
              expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
            end
    
            it '- creates authorization with provider and uid' do
              authorization = User.find_for_oauth(auth).authorizations.first
              
              expect(authorization.provider).to eq auth.provider
              expect(authorization.uid).to eq auth.uid
            end
    
            it '- returns the user' do
              expect(User.find_for_oauth(auth)).to eq user
            end
          end
    
          context 'user does not exists' do
            let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123', info: { email: 'new@user.com' }) }
    
            it '- creates new user' do
              expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
            end
    
            it '- returns new user' do
              expect(User.find_for_oauth(auth)).to be_a(User)
            end
    
            it '- fiils user email' do
              user = User.find_for_oauth(auth)
              expect(user.email).to eq auth.info.email
            end
    
            it '- creates authorization for user' do
              user = User.find_for_oauth(auth)
              expect(user.authorizations).to_not be_empty
            end
    
            it '- creates authorization with provider and uid' do
              authorization = User.find_for_oauth(auth).authorizations.first
    
              expect(authorization.provider).to eq auth.provider
              expect(authorization.uid).to eq auth.uid
            end
          end
        end
      end
  
      context 'Vkontakte' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123123') }
  
        context 'user already has authorization' do
          it '- returns the user' do
            user.authorizations.create(provider: 'vkontakte', uid: '123123')
            expect(User.find_for_oauth(auth)).to eq user
          end
        end
    
        context 'user has not authorization' do
          context 'user already exists' do
            let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123123', info: { email: user.email }) }
    
            it '- does not create new user' do
              expect { User.find_for_oauth(auth) }.to_not change(User, :count)
            end
    
            it '- creates authorization for user' do
              expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
            end
    
            it '- creates authorization with provider and uid' do
              authorization = User.find_for_oauth(auth).authorizations.first
              
              expect(authorization.provider).to eq auth.provider
              expect(authorization.uid).to eq auth.uid
            end
    
            it '- returns the user' do
              expect(User.find_for_oauth(auth)).to eq user
            end
          end
    
          context 'user does not exists' do
            let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: rand(999999).to_s, info: { email: nil }) }
    
            it '- creates new user' do
              expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
            end
    
            it '- returns new user' do
              expect(User.find_for_oauth(auth)).to be_a(User)
            end
    
            it '- fills user temp_email' do
              user = User.find_for_oauth(auth)
              expect(user.email).to eq "#{auth.uid}_temp@temp.com"
            end
    
            it '- creates authorization for user' do
              user = User.find_for_oauth(auth)
              expect(user.authorizations).to_not be_empty
            end
    
            it '- creates authorization with provider and uid' do
              authorization = User.find_for_oauth(auth).authorizations.first
    
              expect(authorization.provider).to eq auth.provider
              expect(authorization.uid).to eq auth.uid
            end
          end
        end
      end
    end
  
    describe '.send_daily_digest' do
      let!(:users) { create_list(:user, 5) }
  
      it '- send daily digest to all users' do
        users.each { |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original }
        User.send_daily_digest
      end
    end
  end
end