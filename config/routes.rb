Rails.application.routes.draw do
  resources :questions, shallow: true do
    resources :answers, shallow: true
  end
end
