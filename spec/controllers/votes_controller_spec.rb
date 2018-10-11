require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:vote) {create(:vote, user: author)}  

  before { sign_in(user) }

  describe 'PATCH #like' do
    context 'with valid attributes' do
      it 'saves new Vote in the database' do
        expect { patch :like, params: { question_id: question, vote: attributes_for(:vote) }, format: :json }.to change(Vote, :count).by(1)
      end

      it 'link Vote with current user' do
        expect{ patch :like, params: { question_id: question, vote: attributes_for(:vote) }, format: :json }.to change(user.votes, :count).by(1)
      end

      it 'render "vote" template' do
        patch :like, params: { question_id: question, vote: attributes_for(:vote) }, format: :json
        expect(response).to render_template 'votes/_vote'
      end
    end
  end

  describe 'PATCH #dislike' do
    context 'with valid attributes' do
      it 'saves new Vote in the database' do
        expect { patch :dislike, params: { question_id: question, vote: attributes_for(:vote) }, format: :json }.to change(Vote, :count).by(1)
      end

      it 'link Vote with current user' do
        expect{ patch :dislike, params: { question_id: question, vote: attributes_for(:vote) }, format: :json }.to change(user.votes, :count).by(1)
      end

      it 'render "vote" template' do
        patch :dislike, params: { question_id: question, vote: attributes_for(:vote) }, format: :json
        expect(response).to render_template 'votes/_vote'
      end
    end
  end

  describe 'DELETE #destroy' do
    
    context 'for author of votes' do
      before { sign_in(author) }

      it 'destroy vote from question' do 
        vote.reload
        expect{ delete :destroy, params: { id: vote }, format: :json }.to change(Vote, :count).by(-1)
      end

      it 'render "destroy" template ' do
        delete :destroy, params: { id: vote }, format: :json
        expect(response).to render_template :destroy
      end
    end

    context 'for non-author of vote' do
      before { sign_in(user) }

      it 'do not destroy vote' do
        vote.reload
        expect{ delete :destroy, params: { id: vote }, format: :json }.to_not change(Vote, :count)
      end
    end
  end
  
end