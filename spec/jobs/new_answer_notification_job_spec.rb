require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let!(:answer) { create(:answer) }

  it "send notification to question's author" do
    expect(NewAnswerNotificationMailer).to receive(:subscribers_notification).with(answer).and_call_original
    NewAnswerNotificationJob.perform_now(answer)
  end
end
