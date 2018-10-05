require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let!(:user) { create(:user) }
  let(:question) { create(:question) }

  before { sign_in(user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render template "index"' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render template "show"' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render template "new"' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'link new Question with current user' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
      end

      it 'redirect to "show" template' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new Question in the database' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-render "new" template' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:question) { create(:question, user: user) }


    context 'User is author of question' do
      before { sign_in(user) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new_title', body: 'new_body' } }, format: :js
          question.reload
          expect(question.title).to eq 'new_title'
          expect(question.body).to eq 'new_body'
        end

        it 'render "update" template' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: { title: 'new_title', body: nil } }, format: :js }

        it 'does not change question attributes' do
          question.reload
          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end

        it 'render "update" template' do
          expect(response).to render_template :update
        end
      end
    end

    context 'User is not author of question' do
      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 'render "update" template' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:user_question) { user.questions.create(title: "Question Title", body: "Question Body") }

    before { sign_in(user) }

    context "for author" do
      it 'deletes the question' do
        user_question
        expect { delete :destroy, params: { id: user_question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context "for non-author" do
      let!(:non_author) { create(:user) }
      before { sign_in(non_author) }

      it 'deletes the question' do
        user_question
        expect { delete :destroy, params: { id: user_question } }.to_not change(Question, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end
end
