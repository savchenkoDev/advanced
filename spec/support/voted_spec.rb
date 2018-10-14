require 'rails_helper'

RSpec.shared_examples_for :voted do
  describe 'PATCH #like' do
    before { sign_in(user) }

    context ' - first time' do
      it 'saves new Vote in the database' do
        expect { patch :like, params: { id: resource  }, format: :json }.to change(resource.votes, :count).by(1)
      end

      it 'assigns attributes to response' do
        patch :like, params: { id: resource }, format: :json
      end

      it 'link Vote with current user' do
        expect{ patch :like, params: { id: resource  }, format: :json }.to change(user.votes, :count).by(1)
      end

      it 'should be successful' do
        patch :like, params: { id: resource  }, format: :json
        expect(response).to be_successful
      end
    end

    context ' - second time' do
      before { create(:vote, user: user, votable: resource) }

      it 'not saves new Vote in the database' do
        expect { patch :like, params: { id: resource  }, format: :json }.to_not change(resource.votes, :count)
      end

      it 'should be not successful' do
        patch :like, params: { id: resource  }, format: :json
        expect(response).to_not be_successful
      end
    end
  end

  describe 'PATCH #dislike' do
    context ' - first time' do
      it 'saves new Vote in the database' do
        expect { patch :dislike, params: { id: resource }, format: :json }.to change(Vote, :count).by(1)
      end

      it 'link Vote with current user' do
        expect{ patch :dislike, params: { id: resource }, format: :json }.to change(user.votes, :count).by(1)
      end

      it 'should be successful' do
        patch :like, params: { id: resource }, format: :json
        expect(response).to be_successful
      end
    end

    context ' - second time' do
      before { create(:vote, user: user, votable: resource) }
      
      it 'not saves new Vote in the database' do
        expect { patch :like, params: { id: resource  }, format: :json }.to_not change(resource.votes, :count)
      end

      it 'should be not successful' do
        patch :like, params: { id: resource  }, format: :json
        expect(response).to_not be_successful
      end
    end
  end

  describe 'DELETE #destroy_vote' do
    
    context 'for author of votes' do
      before { sign_in(author) }

      it 'destroy vote from question' do 
        vote.reload
        expect{ delete :destroy_vote, params: { id: resource }, format: :json }.to change(resource.votes, :count).by(-1)
      end
    end

    context 'for non-author of vote' do
      before { sign_in(user) }

      it 'do not destroy vote' do
        vote.reload
        expect{ delete :destroy_vote, params: { id: resource }, format: :json }.to_not change(resource.votes, :count)
      end
    end
  end
  
end