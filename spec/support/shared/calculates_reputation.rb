RSpec.shared_examples_for 'calculates reputation' do
  let(:user) { create(:user) }
    subject { build(:question, user: user) }
    
    it 'should calculate reputation after create' do
      expect(CalculateReputationJob).to receive(:perform_later).with(subject)
      subject.save!
    end
  
    it 'should not calculate reputation after create' do
      subject.save!
      expect(CalculateReputationJob).to_not receive(:perform_later)
      subject.update(body: 'New title')
    end
end