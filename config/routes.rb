Rails.application.routes.draw do
  root 'top#index'
  resources :netas, only: [:index]
  resources :topics do
    resources :netas, only: [:new, :create, :show, :edit, :update, :destroy], shallow: true do
      resources :trades, only: [:new, :create]
      resources :reviews, only: [:create, :show] do
        resources :comments, only: [:create, :destroy]
      end
    end
    resources :netadrafts, only: [:create, :show, :edit, :update, :destroy]
    resources :comments, only: [:create, :destroy]
  end
  
  post    'topics/:id/likes', to: 'likes#create', as: 'topic_likes'
  delete  'topics/:topic_id/likes/:id', to: 'likes#destroy', as: 'topic_like'
  post    'comments/:id/likes', to: 'likes#create', as: 'comment_likes'
  delete  'comments/:comment_id/likes/:id', to: 'likes#destroy', as: 'comment_like'
  post    'reviews/:id/likes', to: 'likes#create', as: 'review_likes'
  delete  'reviews/:review_id/likes/:id', to: 'likes#destroy', as: 'review_like'
  
  post    'netas/:id/interests', to: 'interests#create', as: 'neta_interests'
  delete  'netas/:neta_id/interests/:id', to: 'interests#destroy', as: 'neta_interest'
  post    'topics/:id/interests', to: 'interests#create', as: 'topic_interests'
  delete  'topics/:topic_id/interests/:id', to: 'interests#destroy', as: 'topic_interest'
  
  get     '/neta/hashtag/:hashname', to: "netas#hashtags"
  post    '/neta/draft', to: "netas#draft"

  resources :copychecks, only: [:new, :create, :show, :update, :index]

  devise_for :users, :controllers => {
    :sessions      => "users/sessions",
    :registrations => "users/registrations",
    :passwords     => "users/passwords"
  }
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  
  resources :users, only: [:show, :edit, :update] do
    resources :follows, only: [:create, :destroy]
    match '/follows/:direction', to: "follows#index", :via => :get
    resources :violations, only: [:new, :create]
    resources :payments, only: [:new, :create, :index]
    resources :subscriptions, only: [:new, :create, :show, :destroy]
    resources :accounts, only: [:new, :create, :show, :edit, :update, :destroy], shallow: true do
      resources :externalaccounts, only: [:new, :create, :edit, :update]
      resources :payouts, only: [:new, :create]
      resources :idcards, only: [:new, :create, :edit, :update, :destroy, :index]
    end
  end
end
