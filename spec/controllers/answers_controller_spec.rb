require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  before { sign_in(user) }
  
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new Answer in the database' do
        expect{ post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'link Answer with current user' do
        expect{ post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(user.answers, :count).by(1)
      end

      it 'redirect to "question/show" template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new Answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 'render "question/show" template' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { question.answers.create(body: "Answer Title", user: user) }

    context 'for author' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(user.answers, :count).by(-1)
      end

      it 'redirect to question/show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'for non-author' do
      let(:non_author) { create(:user) }

      before { sign_in(non_author) }
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(user.answers, :count)
      end

      it 'redirect to question/show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
