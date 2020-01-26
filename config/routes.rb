Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:index, :show] do
    member do
      get 'stats'
      get "following", "followers"
      post 'update_role'
    end
  end
  resources :tips do
    resources :ons, only: [ :create, :destroy ]
    member do
      post 'settle'
      patch 'amend'
      patch 'edit_info'
    end
  end
  resources :posts, only: [ :new, :create, :show, :destroy ]
  resources :relationships, only: [ :create, :destroy ]

  get "/schedule", to: "application#schedule", as: :schedule
  get "/rankings", to: "application#rankings", as: :rankings
  get "/feed", to: "application#feed", as: :feed

  root to: "application#feed"
end
