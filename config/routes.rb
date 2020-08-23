Rails.application.routes.draw do
  root 'top#index'

  resources :topics do
    resources :netas, only: %i[new create]
    resources :comments, only: %i[create destroy]
    resources :likes, only: %i[create destroy]
    resources :bookmarks, only: %i[create destroy]
    resource  :headerimage, only: [:destroy], module: 'topics'
  end

  resources :netas, only: %i[show edit update destroy] do
    resources :trades, only: %i[new create]
    resources :reviews, only: [:create]
    resources :bookmarks, only: %i[create destroy]
  end

  namespace :hashtags do
    resources :netas, only: [:index]
    resources :autocomplete, only: [:index]
  end

  resources :comments, only: [:show] do
    resources :likes, only: %i[create destroy]
  end

  resources :copychecks, only: %i[new create show update index]
  resources :inquiries, only: %i[new create]

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  # match '/auth/:provider/callback', to: 'sessions#create', via: %i[get post]

  resources :users, only: %i[show edit update] do
    resources :followers, only: %i[create destroy index]
    resources :followings, only: [:index]
    resources :violations, only: %i[new create]
    resources :payments, only: %i[new create index]
    resources :subscriptions, only: %i[new create show destroy]
    resources :accounts, only: %i[new create] do
      post :confirm, on: :collection
    end
    resource :avatar, only: [:destroy], module: 'users'
  end

  resources :accounts, only: %i[show edit update destroy] do
    patch :confirm, on: :member
    resources :externalaccounts, only: %i[new create]
    resources :payouts, only: %i[new create]
    resources :idcards, only: %i[new create index]
  end
  resources :externalaccounts, only: %i[edit update]
  resources :idcards, only: %i[edit update destroy]
  resources :bank_autocomplete, only: [:index]
  resources :branch_autocomplete, only: [:index]

  post '/trades/webhook', to: 'trades#webhook', as: 'trade_webhook'
end
