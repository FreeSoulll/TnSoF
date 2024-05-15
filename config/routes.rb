Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true
    resource :best_answer, only: [:create]
  end
  resource :attached_file, only: [:destroy]
end
