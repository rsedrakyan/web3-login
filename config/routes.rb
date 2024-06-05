Rails.application.routes.draw do
  resource :sessions, only: [:new, :create, :destroy]
  resources :nonces, only: [:show], param: :address

  root to: 'home#index'
end
