require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:non_author) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:attachment) { create(:attachment, attachable: question) }
  
  describe 'DELETE #destroy' do
    
    context 'for author of entity' do
      before { sign_in(user) }

      it 'destroy attachment from question' do 
        attachment.reload
        expect{ delete :destroy, params: { id: attachment }, format: :js }.to change(Attachment, :count).by(-1)
      end

      it 'render "destroy" template ' do
        delete :destroy, params: { id: attachment }, format: :js 
        expect(response).to render_template :destroy
      end
    end

    context 'for non-author of entity' do
      before { sign_in(non_author) }

      it ' do not destroy attachment from question' do
        attachment.reload
        expect{ delete :destroy, params: { id: attachment }, format: :js }.to_not change(Attachment, :count)
      end
    end
  end
end
  
  