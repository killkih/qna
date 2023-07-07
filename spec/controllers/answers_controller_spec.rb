require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      let(:operation) { post :create, params: { answer: attributes_for(:answer), question_id: question } }

      it 'saves a new answer in the database' do
        expect { operation }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        expect(operation).to redirect_to question_path(question)
      end

      it 'saves a answer with correct association' do
        operation
        expect(assigns(:ex_answer).question_id).to eq question.id
      end
    end

    context 'with invalid attributes' do
      let(:operation) { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }

      it 'does not save the answer' do
        expect { operation }.to_not change(Answer, :count)
      end

      it 're-render new view' do
        expect(operation).to redirect_to question_path(question)
      end
    end
  end
end