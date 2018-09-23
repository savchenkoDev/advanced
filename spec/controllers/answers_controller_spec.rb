require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  
  
  describe 'GET #index' do
    let(:answers) { question.answers.create!(body: "Answer's body", user_id: user.id) }
    before { get :index, params: { question_id: question } }
    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end
    
    it 'render template "index"' do
      expect(response).to render_template :index
    end
  end
  
  describe 'GET #new' do
    it 'assigns a new Answer to @answer' do
      sign_in(user)
      get :new, params: {question_id: question}
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render template "new"' do
      sign_in(user)
      get :new, params: {question_id: question}
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new Answer in the database' do
        sign_in(user)
        expect{ post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirect to "show" template fot Question' do
        sign_in(user)
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        # byebug
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new Answer in the database' do
        sign_in(user)
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 're-render "new" template' do
        sign_in(user)
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template :new
      end
    end
  end
end
