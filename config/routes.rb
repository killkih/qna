# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', confirmations: 'confirmations' }
  root to: 'questions#index'

  post 'users/auth_without_email', to: 'users#auth_without_email', as: :auth_without_email

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

  resources :questions, concerns: %i[votable commentable], shallow: true do
    resources :answers, concerns: %i[votable commentable], shallow: true, only: %i[create destroy update] do
      member do
        post :mark_as_best
        delete 'purge/:file', to: 'answers#purge', as: 'purge'
      end
    end

    delete 'purge/:file', to: 'questions#purge', as: 'purge', on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create update destroy]
      end
    end
  end

  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
