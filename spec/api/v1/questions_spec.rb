require "rails_helper"

describe 'Questions API' do
  describe 'GET /me' do
    context 'Unauthorized' do
      it '- returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response).to have_http_status(401)
      end

      it '- returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { access_token: '1234', format: :json }
        expect(response).to have_http_status(401)
      end
    end

    context 'Authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let!(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it '- returns 200 status' do
        expect(response).to have_http_status(200)
      end

      it '- returns list of questions' do
        expect(response.body).to have_json_size(questions.size)
      end

      %w[id title created_at updated_at body].each do |attr|
        it "- question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('0/short_title')
      end

      context 'Answers' do
        it '- included in question object' do
          expect(response.body).to have_json_size(1).at_path('0/answers')
        end

        %w[id body created_at updated_at].each do |attr|
          it "- contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end
  end
end
