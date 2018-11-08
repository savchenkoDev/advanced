require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { build(:question) }

  describe 'concerns' do
    it_behaves_like 'votable'
    it_behaves_like 'attachable'
    it_behaves_like 'commentable'
  end

  describe 'asoociations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:attachments) }
    it { should belong_to(:user) }
  end
  
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end
  
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
  end
end
