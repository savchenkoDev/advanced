require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 3, question: question) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:attachments) }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(6) }

  it { should accept_nested_attributes_for :attachments }

  describe 'method "set_best":' do
    before do 
      answers.last.set_best
      answers.first.set_best
    end

    it 'set answer by best' do
      expect(answers.first).to be_best
    end

    it 'set only one best answer' do
      expect(question.answers.where(best: true).count).to eq 1
    end
  end
  
end
