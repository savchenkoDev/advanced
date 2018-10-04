require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let(:answer) { create(:answer) }

  before { sign_in(user) }
  
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
      let(:non_author) { create(:user) }

      before { sign_in(non_author) }
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(user.answers, :count)
      end

      it 'redirect to question/show view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question) }
    context 'with valid attributes' do
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
  end

  describe 'PATCH #set_best' do
    let(:answer) { create(:answer) }
    it 'assigns the requested answer to @answer' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update, params: { id: answer, question_id: question, answer: { body: 'new_body' } }, format: :js
      answer.set_best
      expect(answer.best).to eq true
    end

    it 'render template "set_best"' do
      patch :set_best, params: { id: answer}, format: :js
      expect(response).to render_template :set_best
    end
  end
end
