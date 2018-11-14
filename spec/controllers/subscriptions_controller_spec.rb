require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  
  describe "POST #create" do
    describe "for authenticate user" do
      before { sign_in(user) }
      
      it '- returns status 200' do
        post :create, params: { question_id: question.id }, format: :js
        expect(response).to have_http_status(200)
      end
  
      it '- save new subscription for user' do
        expect { post :create, params: { question_id: question.id }, format: :js }.to change(user.subscriptions, :count).by(1)
      end
    end

    describe 'for unauthenticate user' do
      it '- returns status 401' do
        post :create, params: { question_id: question.id }, format: :js
        expect(response).to have_http_status(401)
      end

      it '- does not save new subscription for user' do
        expect { post :create, params: { question_id: question.id }, format: :js }.to_not change(user.subscriptions, :count)
      end
    end
    
  end

  describe 'DELETE #destroy' do
    let(:subscription) { create(:subscription, user: user, question: question) }

    describe 'for authenticate user' do
      before { sign_in(user) }
  
      it '- returns status 200' do
        delete :destroy, params: { id: subscription.id }, format: :js
        expect(response).to have_http_status(200)
      end
  
      it '- destroy subscription' do
        subscription
        expect { delete :destroy, params: { id: subscription.id }, format: :js }.to change(Subscription, :count).by(-1)
      end
    end

    describe 'for unauthenticate user' do
      it '- returns status 401' do
        delete :destroy, params: { id: subscription.id }, format: :js
        expect(response).to have_http_status(401)
      end

      it '- does not destroy subscription' do
        subscription
        expect { delete :destroy, params: { id: subscription.id }, format: :js }.to_not change(Subscription, :count)
      end

    end
    
    
  end
  
end
