require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question) }

  it "send notification to question's author" do
    expect(NewAnswerNotificationMailer).to receive(:subscribers_notification).with(answer, user).and_call_original
    NewAnswerNotificationJob.perform_now(answer)
  end
end
