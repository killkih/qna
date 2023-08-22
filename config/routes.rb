# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      post :like
      post :dislike
      post :cancel_vote
    end
  end

  concern :commentable do
    member { post :add_comment }
  end

  resources :questions, concerns: [:votable, :commentable], shallow: true do
    resources :answers, concerns: [:votable, :commentable], shallow: true, only: %i[create destroy update] do
      member do
        post :mark_as_best
        delete 'purge/:file', to: 'answers#purge', as: 'purge'
      end
    end

    delete 'purge/:file', to: 'questions#purge', as: 'purge', on: :member
  end

  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
