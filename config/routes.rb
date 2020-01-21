Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:index, :show] do
    member do
      post 'update_role'
    end
  end
  resources :tips do
    member do
      post 'settle'
      patch 'amend'
      patch 'edit_info'
    end
  end

  get "/schedule", to: "application#schedule", as: :schedule
  get "/rankings", to: "application#rankings", as: :rankings

  root to: 'home#index'
end
