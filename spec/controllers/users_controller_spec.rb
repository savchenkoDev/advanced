require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'PATCH #update_email' do
    let(:user) { create(:user) }

    before { sign_in(user) }

    context 'with valid attributes' do
      it '- changes user email' do
        patch :update_email, params: { user_id: user, email: 'new_email@email.com' }
        user.reload
        expect(user.email).to eq 'new_email@email.com'
      end

      it '- redirect to root_path' do
        patch :update_email, params: { user_id: user, email: 'new_email@email.com' }
        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid attributes' do
      it '- does not changes user email' do
        email = user.email
        patch :update_email, params: { user_id: user, email: nil }
        user.reload
        expect(user.email).to eq email
      end

      it '- render template "edit_email"' do
        patch :update_email, params: { user_id: user, email: nil }
        expect(response).to render_template :edit_email
      end
    end
  end
end
