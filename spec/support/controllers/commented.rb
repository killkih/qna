require 'rails_helper'

shared_examples_for 'commented' do
  describe 'POST #add_comment' do
    let!(:commentable) { create(described_class.controller_name.singularize.to_sym) }

    context 'unauthenticated user' do
      it 'can not add comment' do
        expect do
          post :add_comment, params: { id: commentable, body: 'test' }
        end.to_not change(Comment, :count)
      end
    end

    context 'authenticated user', js: true do
      before { login(user) }

      it 'can add comment with valid attributes' do
        expect do
          post :add_comment, params: { id: commentable, body: 'test' }, format: :js
        end.to change(Comment, :count).by(1)
      end

      it 'can not add comment with invalid attributes' do
        expect do
          post :add_comment, params: { id: commentable, body: '' }, format: :js
        end.to_not change(Comment, :count)
      end
    end
  end
end

