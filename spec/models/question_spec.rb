require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { build(:question) }
  it_behaves_like 'votable'
  it_behaves_like 'attachable'
  it_behaves_like 'commentable'
  
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments) }
  it { should belong_to(:user) }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  context "reputation" do
    let(:user) { create(:user) }
    subject { build(:question, user: user) }
    
    it ' -should calculate reputation after create' do
      expect(Reputation).to receive(:calculate).with(subject)
      subject.save!
    end
  
    it '- should not calculate reputation after create' do
      subject.save!
      expect(Reputation).to_not receive(:calculate)
      subject.update(title: 'New title')
    end
  
    it ' -should save user reputation' do
      allow(Reputation).to receive(:calculate).and_return(5)
      expect { subject.save! }.to change(user, :reputation).by(5)
    end

    it 'test time' do
      now = Time.now.utc
      allow(Time).to receive(:now) { now }
      subject.save!
      expect(subject.created_at).to eq now
    end
  end
end
