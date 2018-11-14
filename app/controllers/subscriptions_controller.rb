class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  respond_to :js

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @subscription = @question.subscriptions.create(user: current_user)
    respond_with @subscription
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy if current_user.author_of?(@subscription)
  end
  
end
