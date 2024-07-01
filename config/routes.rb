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
  get 'new_user', to: 'users#new', as: 'new_user'
  post 'create_user', to: 'users#create', as: 'create_user'

  mount ActionCable.server => '/cable'
end
