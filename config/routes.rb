Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

  concern :votable do
    member do
      patch :up_vote
      patch :down_vote
    end
  end

  concern :commentable do
    member do
      patch :add_comment
    end
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, concerns: %i[votable commentable], shallow: true
    resource :best_answer, only: [:create]
  end
  resource :attached_file, only: [:destroy]
  resource :links, only: [:destroy]
  resources :awards, only: [:index]
  resources :users do
    collection do
      post 'create_user'
    end
  end

  mount ActionCable.server => '/cable'
end
