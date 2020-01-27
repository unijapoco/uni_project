Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: "users/registrations" }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:index, :show] do
    member do
      get 'following', 'followers'
      post 'update_role'
      post 'update_extra'
    end
  end
  resources :tips do
    resources :ons, only: [ :create, :destroy ]
    resources :tip_comments, only: [ :create, :destroy ]
    member do
      post 'settle'
      patch 'amend'
      get 'edit_info'
      patch 'update_info'
    end
  end
  resources :posts, only: [ :new, :create, :show, :destroy ] do
    resources :likes, only: [ :create, :destroy ]
    resources :post_comments, only: [ :create, :destroy ]
  end
  resources :relationships, only: [ :create, :destroy ]

  get "/schedule", to: "application#schedule", as: :schedule
  get "/rankings", to: "application#rankings", as: :rankings
  get "/feed", to: "application#feed", as: :feed
  get "/search_user", to: "application#search_user", as: :search_user

  root to: "application#feed"
end
