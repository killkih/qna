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

      it 're-render new view' do
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
end
