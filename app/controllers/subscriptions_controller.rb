class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  respond_to :js

  def create
    @question = Question.find(params[:question_id])
    @subscription = @question.subscriptions.create!(user: current_user)
    respond_with @subscription
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    respond_to @subscription.destroy
  end
  
end
