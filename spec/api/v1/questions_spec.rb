require "rails_helper"

describe 'Questions API' do
  describe 'GET /index' do
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

  describe 'GET /show' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let(:comment) { comments.first }
    let!(:attachments) { create_list(:attachment, 2, attachable: question) }
    let(:attachment) { attachments.first }

    context 'Unauthorized' do
      it '- returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response).to have_http_status(401)
      end

      it '- returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", params: { access_token: '1234', format: :json }
        expect(response).to have_http_status(401)
      end
    end

    context 'Authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it '- returns 200 status' do
        expect(response).to have_http_status(200)
      end

      context '- contains' do
        %w[id title body user_id created_at updated_at].each do |attr|
          it "- #{attr}" do
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
          end
        end
      end

      context '- attachments ' do
        it '- included in question object' do
          expect(response.body).to have_json_size(attachments.size).at_path('attachments')
        end

        it '- contains url' do
          
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('attachments/0/url')
        end
      end

      context '- comments' do
        it '- included in question object' do
          expect(response.body).to have_json_size(comments.size).at_path('comments')
        end

        %w[id text user_id].each do |attr|
          it "- contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST /create' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:attrs) { attributes_for(:question, user: user) }
    let(:invalid_attrs) { attributes_for(:invalid_question, user: user) }

    context 'Unauthorized' do
      it '- returns 401 status if there is no access_token' do
        get "/api/v1/questions", params: { format: :json }
        expect(response).to have_http_status(401)
      end

      it '- returns 401 status if access_token is invalid' do
        get "/api/v1/questions", params: { access_token: '1234', format: :json }
        expect(response).to have_http_status(401)
      end
    end

    context 'authorized' do
      context '- invalid attributes' do
        it '- returns 422 status' do
          post "/api/v1/questions", params: { access_token: access_token.token, question: invalid_attrs, format: :json }
          expect(response).to have_http_status(422)
        end
      end

      context "- valid attributes" do
        before { post "/api/v1/questions", params: { access_token: access_token.token, question: attrs, format: :json } }
    
        it '- returns status 201-Created' do
          expect(response).to have_http_status(201)
        end
  
        %w[title body user_id created_at updated_at attachments comments].each do |attr|
          it "- contains #{attr}" do
            expect(response.body).to have_json_path(attr)
          end
        end
  
        %w[title body].each do |attr|
          it "- set #{attr}" do
            expect(response.body).to be_json_eql(attrs[attr.to_sym].to_json).at_path(attr)
          end
        end
  
        it '- set user_id' do
          expect(response.body).to be_json_eql(user.id.to_json).at_path('user_id')
        end
      end
    end
  end  
end
