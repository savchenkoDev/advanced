require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { build(:question) }

  describe 'concerns' do
    it_behaves_like 'votable'
    it_behaves_like 'attachable'
    it_behaves_like 'commentable'
  end

  describe 'asoociations' do
    it { should belong_to(:user) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:attachments) }
    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_many(:subscribers).through(:subscriptions) } 
  end
  
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end
  
  it { should accept_nested_attributes_for :attachments }

  context "reputation" do
    it_behaves_like 'calculates reputation'
  end

  context 'subscription' do
    let!(:question) { create(:question) } 

    it 'after create add subscribe for author' do
      expect(question.subscribers.count).to eq 1
    end
  end
end
