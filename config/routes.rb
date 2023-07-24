# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, shallow: true do
    resources :answers, shallow: true, only: %i[create destroy update] do
      member do
        post :mark_as_best
        delete 'purge/:file', to: "answers#purge", as: "purge"
      end
    end
  end
end
