require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:session) { { oauth:  {'provider' => 'vkontakte', 'uid' => '123' } } }

  describe 'POST #auth_without_email' do

    context 'without oauth params' do
      it 'redirect to root path' do
        post :auth_without_email
        expect(response).to redirect_to root_path
      end
    end

    context 'with oauth params' do
      context 'with correct params' do

        it 'redirect with correct params' do
          post :auth_without_email, params: { user: { email: 'test@test.com'} }, session: session
          expect(response).to redirect_to root_path
        end

        it 'create authorization' do
          expect do
            post :auth_without_email, params: { user: { email: 'test@test.com'} }, session: session
          end.to change(Authorization, :count).by(1)
        end
      end

      context 'with incorrect params' do
        it 'redirect with incorrect email' do
          post :auth_without_email, params: { user: { email: '121212'} }, session: session
          expect(response).to render_template :auth_without_email
        end

        it 'fail create authorization' do
          expect do
            post :auth_without_email, params: { user: { email: '121212'} }, session: session
          end.to_not change(Authorization, :count)
        end
      end
    end

    context 'email existed' do
      let!(:user) { create(:user, email: 'test@test.com') }

      it 'render template' do
        post :auth_without_email, params: { user: { email: 'test@test.com'} }, session: session
        expect(response).to render_template :auth_without_email
      end

      it 'fail create authorization' do
        expect do
          post :auth_without_email, params: { user: { email: 'test@test.com'} }, session: session
        end.to_not change(Authorization, :count)
      end
    end
  end
end
