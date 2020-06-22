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
    resources :comments, only: [:create, :destroy]
  end
  delete  'topics/:topic_id/delete_header_image', to: 'topics#delete_header_image', as: 'topic_header_image' #member

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
  
  get     '/neta/hashtag/:hashname', to: "netas#hashtags", as: 'netas_hashtags'
  get     '/neta/tag_search_autocomplete', to: "netas#tag_search_autocomplete"
  post    '/neta/draft', to: "netas#draft"
 
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
    resources :follows, only: [:create, :destroy]
    get '/follows/:direction', to: "follows#index", as: 'follows_idx'
    resources :violations, only: [:new, :create]
    resources :payments, only: [:new, :create, :index]
    resources :subscriptions, only: [:new, :create, :show, :destroy]
    resources :accounts, only: [:new, :create, :show, :edit, :update, :destroy], shallow: true do
      resources :externalaccounts, only: [:new, :create, :edit, :update]
      resources :payouts, only: [:new, :create]
      resources :idcards, only: [:new, :create, :edit, :update, :destroy, :index]
    end
  end
  post    '/users/:user_id/accounts/confirm', to: "accounts#confirm", as: 'accounts_new_confirm'
  patch   '/accounts/:id/confirm', to: "accounts#confirm", as: 'accounts_edit_confirm'
  delete  '/users/:id/delete_avatar', to: 'users#delete_avatar', as: 'delete_avatar'
  get     '/externalaccounts/bank_search_autocomplete', to: "externalaccounts#bank_search_autocomplete"
  get     '/externalaccounts/branch_search_autocomplete', to: "externalaccounts#branch_search_autocomplete"
  post    '/trades/webhook', to: "trades#webhook", as: 'trade_webhook'
  
end
