# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, shallow:true do
    resources :answers, shallow: true, only: %i[create destroy update]
  end
end
