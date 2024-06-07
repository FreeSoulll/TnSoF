Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      patch :up_vote
      patch :down_vote
    end
  end

  resources :questions, concerns: %i[votable] do
    resources :answers, concerns: %i[votable], shallow: true
    resource :best_answer, only: [:create]
  end
  resource :attached_file, only: [:destroy]
  resource :links, only: [:destroy]
  resources :awards, only: [:index]
end
