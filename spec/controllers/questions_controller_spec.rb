# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: other_user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }
    it 'assigns the requested Question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Link' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new Reward' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end
    end

    context 'DELETE #destroy' do
      before { login(user) }

      let!(:question) { create(:question, user: user) }

      it 'delete the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end

  describe 'DELETE #purge' do
    before { login(user) }

    let!(:question) do
      create(:question,
             user: user,
             files: [Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb")])
    end

    it 'delete attached file' do
      expect do
        delete :purge, params: { id: question, file: question.files[0] }
      end.to change(question.files, :count).by(-1)
    end
  end

  describe 'POST #like' do
    context 'unauthenticated user' do
      it 'can not like the question' do
        expect do
          post :like, params: { id: question }, format: :json
        end.to_not change(Vote, :count)
      end
    end

    context 'authenticated user' do
      before { login(user) }

      it 'like the question' do
        expect do
          post :like, params: { id: question.id }, format: :json
        end.to change(Vote, :count).by(1)
      end

      it 'render question with json' do
        body = { id: question.id, rating: 1 }.to_json

        post :like, params: { id: question }, format: :json
        expect(response.body).to eq body
      end
    end

    context 'author of the question' do
      before { login(other_user) }

      it 'can not like the question' do
        expect do
          post :like, params: { id: question }, format: :json
        end.to_not change(Vote, :count)
      end
    end
  end

  describe 'POST #dislike' do
    context 'unauthenticated user' do
      it 'can not dislike the question' do
        expect do
          post :dislike, params: { id: question }, format: :json
        end.to_not change(Vote, :count)
      end
    end

    context 'authenticated user' do
      context 'user' do
        before { login(user) }

        it 'dislike question' do
          expect do
            post :dislike, params: { id: question }, format: :json
          end.to change(Vote, :count).by(1)
        end

        it 'render question with json' do
          body = { id: question.id, rating: -1 }.to_json

          post :dislike, params: { id: question }, format: :json
          expect(response.body).to eq body
        end
      end

      context 'author of the question' do
        before { login(other_user) }

        it 'can not dislike the question' do
          expect do
            post :dislike, params: { id: question }, format: :json
          end.to_not change(Vote, :count)
        end
      end
    end
  end

  describe 'POST #cancel_vote' do
    let!(:vote) { create(:vote, user: user, votable: question) }

    context 'unauthenticated user' do
      it 'can not cancel vote' do
        expect do
          post :cancel_vote, params: { id: question }, format: :json
        end.to_not change(Vote, :count)
      end
    end

    context 'authenticated user' do
      context 'user' do
        before { login(user) }

        it 'can cancel vote' do
          expect do
            post :cancel_vote, params: { id: question }, format: :json
          end.to change(Vote, :count).by(-1)
        end

        it 'render question with json' do
          post :cancel_vote, params: { id: question }, format: :json
          body = { id: question.id, rating: question.rating }.to_json
          expect(response.body).to eq body
        end
      end

      context 'author of the question' do
        before { login(other_user) }

        it 'can not cancel vote' do
          expect do
            post :cancel_vote, params: { id: question }, format: :json
          end.to_not change(Vote, :count)
        end
      end
    end
  end

  describe 'POST #add_comment' do
    let!(:question) { create(:question) }

    context 'unauthenticated user' do
      it 'can not add comment' do
        expect do
          post :add_comment, params: { id: question, body: 'test' }
        end.to_not change(Comment, :count)
      end
    end

    context 'authenticated user', js: true do
      before { login(user) }

      it 'can add comment with valid attributes' do
        expect do
          post :add_comment, params: { id: question, body: 'test' }, format: :js
        end.to change(Comment, :count).by(1)
      end

      it 'can not add comment with invalid attributes' do
        expect do
          post :add_comment, params: { id: question, body: '' }, format: :js
        end.to_not change(Comment, :count)
      end
    end
  end
end
