Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true
    patch :set_the_best_answer, on: :member
  end
end
