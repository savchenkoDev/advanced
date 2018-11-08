require "rails_helper"

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like 'API authenticable'

    context 'Authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it '- returns 200 status' do
        expect(response).to have_http_status(200)
      end

      %w[id email created_at updated_at admin].each do |attr|
        it "- contain #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w[password encrypted_password].each do |attr|
        it "- does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def send_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /index' do
    it_behaves_like 'API authenticable'

    context 'Authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:others) { create_list(:user, 2) }

      before { get '/api/v1/profiles', params: { format: :json, access_token: access_token.token } }

      it '- returns 200 status' do
        expect(response).to have_http_status(200)
      end

      it '- does not returns current user' do
        expect(response.body).to_not include_json(me.to_json)
      end

      it '- returns other users list' do
        expect(response.body).to be_json_eql(others.to_json).at_path('/')
      end

      %w[id email created_at updated_at admin].each do |attr|
        it "- contain #{attr}" do
          expect(response.body).to be_json_eql(others.first.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
      
      %w[password encrypted_password].each do |attr|
        it "- does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def send_request(options = {})
      get '/api/v1/profiles', params: { format: :json }.merge(options)
    end
  end
end
