require 'rails_helper'

shared_examples_for 'voted' do
  describe 'POST #like' do
    let(:votable) { create(described_class.controller_name.singularize.to_sym, user: other_user) }

    context 'unauthenticated user' do
      it 'can not like the answer' do
        expect do
          post :like, params: { id: votable }, format: :json
        end.to_not change(Vote, :count)
      end
    end

    context 'authenticated user' do
      before { login(user) }

      it 'like the answer' do
        expect do
          post :like, params: { id: votable.id }, format: :json
        end.to change(Vote, :count).by(1)
      end

      it 'render answer with json' do
        body = { id: votable.id, rating: 1 }.to_json

        post :like, params: { id: votable }, format: :json
        expect(response.body).to eq body
      end
    end

    context 'author of the answer' do
      before { login(other_user) }

      it 'can not like the answer' do
        expect do
          post :like, params: { id: votable }, format: :json
        end.to_not change(Vote, :count)
      end
    end
  end

  describe 'POST #dislike' do
    let(:votable) { create(described_class.controller_name.singularize.to_sym, user: other_user) }

    context 'unauthenticated user' do
      it 'can not dislike the answer' do
        expect do
          post :dislike, params: { id: votable }, format: :json
        end.to_not change(Vote, :count)
      end
    end

    context 'authenticated user' do
      context 'user' do
        before { login(user) }

        it 'dislike answer' do
          expect do
            post :dislike, params: { id: votable }, format: :json
          end.to change(Vote, :count).by(1)
        end

        it 'render answer with json' do
          body = { id: votable.id, rating: -1 }.to_json

          post :dislike, params: { id: votable }, format: :json
          expect(response.body).to eq body
        end
      end

      context 'author of the answer' do
        before { login(other_user) }

        it 'can not dislike the answer' do
          expect do
            post :dislike, params: { id: votable }, format: :json
          end.to_not change(Vote, :count)
        end
      end
    end
  end

  describe 'POST #cancel_vote' do
    let(:votable) { create(described_class.controller_name.singularize.to_sym) }
    let!(:vote) { create(:vote, user: user, votable: votable) }

    context 'unauthenticated user' do
      it 'can not cancel vote' do
        expect do
          post :cancel_vote, params: { id: votable }, format: :json
        end.to_not change(Vote, :count)
      end
    end

    context 'authenticated user' do
      context 'user' do
        before { login(user) }

        it 'can cancel vote' do
          expect do
            post :cancel_vote, params: { id: votable }, format: :json
          end.to change(Vote, :count).by(-1)
        end

        it 'render answer with json' do
          post :cancel_vote, params: { id: votable }, format: :json
          body = { id: votable.id, rating: votable.rating }.to_json
          expect(response.body).to eq body
        end
      end

      context 'author of the answer' do
        before { login(other_user) }

        it 'can not cancel vote' do
          expect do
            post :cancel_vote, params: { id: votable }, format: :json
          end.to_not change(Vote, :count)
        end
      end
    end
  end
end
