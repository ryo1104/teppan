# frozen_string_literal: true

Rails.application.routes.draw do
  root 'top#index'

  resources :top, only: [:index]
  resources :topics do
    resources :netas, only: %i[new create]
    resources :comments, only: %i[create destroy]
    resources :likes, only: %i[create destroy]
    resources :bookmarks, only: %i[create destroy]
    resource  :headerimage, only: %i[destroy], module: 'topics'
  end

  resources :netas, only: %i[show edit update destroy] do
    resources :trades, only: %i[new create]
    resources :reviews, only: [:create]
    resources :bookmarks, only: %i[create destroy]
  end

  match '/trades/webhook' => 'trades#webhook', :via => %i[get post]

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

  resources :users, only: %i[show edit update] do
    resources :followers, only: %i[create destroy index]
    resources :followings, only: [:index]
    resources :violations, only: %i[new create]
    resources :accounts, module: 'business', only: %i[new create] do
      post :confirm, on: :collection
    end
    resource :avatar, only: [:destroy], module: 'users'
  end

  scope module: :business do
    resources :accounts, only: %i[show edit update destroy] do
      patch :confirm, on: :member
      resources :payouts, only: %i[new create]
      resources :idcards, only: %i[new create]
      resource  :extacct, only: %i[new create edit update]
    end
    resources :idcards, only: [:destroy]
    resources :bank_autocomplete, only: [:index]
    resources :branch_autocomplete, only: [:index]
  end

  resources :emailrecs, only: %i[index show]
  resource :policy, only: [:show]
  resource :userterm, only: [:show]
  resource :tokutei, only: [:show]
end
