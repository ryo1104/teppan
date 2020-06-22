Rails.application.routes.draw do
  root 'top#index'

  resources :topics do
    resources :netas, only: [:new, :create]
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
    resources :interests, only: [:create, :destroy]
    delete :delete_header_image, on: :member
  end

  resources  :netas, only: [:show, :edit, :update, :destroy] do
    resources :trades, only: [:new, :create]
    resources :reviews, only: [:create]
    resources :interests, only: [:create, :destroy]
  end
  resources :hashtags, only: [:index]
  resources :hashtag_autocomplete, only: [:index]
  resources :reviews, only: [:show]

  resources :comments, only: [:show] do
    resources :likes, only: [:create, :destroy]
  end

  resources :copychecks, only: [:new, :create, :show, :update, :index]
  resources :inquiries, only: [:new, :create]

  devise_for :users, :controllers => {
    :sessions      => "users/sessions",
    :registrations => "users/registrations",
    :passwords     => "users/passwords",
    :confirmations => "users/confirmations"
  }
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]

  resources :users, only: [:show, :edit, :update] do
    resources :followers, only: [:create, :destroy, :index]
    resources :followings, only: [:index]
    resources :violations, only: [:new, :create]
    resources :payments, only: [:new, :create, :index]
    resources :subscriptions, only: [:new, :create, :show, :destroy]
    resources :accounts, only: [:new, :create] do
      post :confirm, on: :collection
    end
    delete :delete_avatar, on: :member
  end

  resources :accounts, only: [:show, :edit, :update, :destroy] do
    patch :confirm, on: :member
    resources :externalaccounts, only: [:new, :create]
    resources :payouts, only: [:new, :create]
    resources :idcards, only: [:new, :create, :index]
  end
  resources :externalaccounts, only: [:edit, :update]
  resources :idcards, only: [:edit, :update, :destroy]
  resources :bank_autocomplete, only: [:index]
  resources :branch_autocomplete, only: [:index]

  post    '/trades/webhook', to: "trades#webhook", as: 'trade_webhook'
  
end
