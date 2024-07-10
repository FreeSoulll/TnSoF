Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: {
    omniauth_callbacks: 'oauth_callbacks',
    sessions: 'sessions',
    registrations: 'registrations',
    passwords: 'passwords'
  }
  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resource :profiles, only: [] do
        get :me, on: :collection
        get :all_users, on: :collection
      end
      resources :questions, shallow: true do
        resources :answers
      end
    end
  end

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
