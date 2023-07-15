# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create :question, user: user }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      let(:operation) { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }

      it 'saves a new answer in the database' do
        expect { operation }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        expect(operation).to render_template :create
      end

      it 'saves a answer with correct association' do
        operation
        expect(assigns(:answer).question_id).to eq question.id
      end
    end

    context 'with invalid attributes' do
      let(:operation) { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }

      it 'does not save the answer' do
        expect { operation }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        expect(operation).to render_template :create
      end
    end
  end

  describe 'PATCH #destroy' do
    before { login(user) }

    let!(:answer) { create(:answer, user: user, question: question) }

    it 'delete the answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end
    it 'redirect to question' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_path(question)
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end
    end

  end
end
