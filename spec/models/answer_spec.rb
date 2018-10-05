require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 3, question: question) }

  before { answers.last.set_best }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(6) }

  describe 'method "set_best":' do
    before do 
      answers.last.set_best
      answers.first.set_best
    end

    it 'set answer by best' do
      expect(answers.first.best).to be_best
    end

    it 'set only one best answer' do
      expect(question.answers.where(best: true).count).to eq 1
    end
  end
  
end
