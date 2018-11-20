module QuestionsHelper
  def current_user_subscription(question)
    subscription_path(question.subscriptions.where(user_id: current_user.id).first)
  end
end
