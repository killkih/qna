# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  describe 'POST #create' do
    before { login(user) }

    it 'saves a subscription in the database' do
      expect { post :create, params: { question_id: question }, format: :js }.to change(Subscription, :count).by(1)
    end

    it 'renders create template' do
      post :create, params: { question_id: question }, format: :js
      expect(response).to render_template :create
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:subscription) { create(:subscription, question: question, user: user) }

    it 'deletes a subscription in the database' do
      expect { delete :destroy, params: { question_id: question }, format: :js }.to change(Subscription, :count).by(-1)
    end

    it 'renders to updated question' do
      delete :destroy, params: { question_id: question }, format: :js
      expect(response).to render_template :destroy
    end
  end
end
