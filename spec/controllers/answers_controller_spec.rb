require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:non_author) { create(:user) }
  let!(:question) { create(:question) }
  let(:answer) { create(:answer) }

  before { sign_in(user) }

  describe 'for vote actions' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:resource) { create(:answer, user: author) }
    let(:vote) { create(:vote, votable: resource, user: author)}

    it_behaves_like 'voted'
  end

  describe 'for comment actions' do
    let(:author) { create(:user) }
    let(:resource) { create(:answer, user: author) }

    it_behaves_like 'commented', commentable: 'answer'
  end
  
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new Answer in the database' do
        expect{ post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'link Answer with current user' do
        expect{ post :create, params: { question_id: question, answer: attributes_for(:answer) } , format: :js }.to change(user.answers, :count).by(1)
      end

      it 'render "answers/create" template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template 'answers/create'
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new Answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }, format: :js }.to_not change(Answer, :count)
      end

      it 'render "answers/create" template' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }, format: :js
        expect(response).to render_template 'answers/create'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { question.answers.create(body: "Answer Title", user: user) }

    context 'for author' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(user.answers, :count).by(-1)
      end

      it 'render to "destoy" view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'for non-author' do
      before { sign_in(non_author) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(user.answers, :count)
      end

      it 'have http status "Forbidden"' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question, user: user) }

    context 'author of answer' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new_body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new_body'
      end

      it 'render "update" template' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Not author of answer' do
      before { sign_in(non_author) }
      
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'not changes answer attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new_body' } }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new_body'
      end

      it 'have http status "Forbidden"' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'PATCH #set_best' do
    let(:answer) { create(:answer, question: question, user: user) }

    context 'user is author of question' do
      it 'assigns the requested answer to @answer' do
        patch :set_best, params: { id: answer }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        expect{ patch :set_best, params: { id: answer }, format: :js }.to_not change(answer, :best)
      end

      it 'have http status "Forbidden"' do
        patch :set_best, params: { id: answer }, format: :js
        expect(response).to have_http_status(403)
      end
    end

    context 'user is not author of question' do
      before {sign_in(non_author)}

      it 'assigns the requested answer to @answer' do
        patch :set_best, params: { id: answer }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it "can't changes answer attributes" do
        expect{ patch :set_best, params: { id: answer }, format: :js }.to_not change(answer, :best)
      end
      
      it 'have http status "Forbidden"' do
        patch :set_best, params: { id: answer }, format: :js
        expect(response).to have_http_status(403)
      end
    end
  end
end
