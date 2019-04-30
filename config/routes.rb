Rails.application.routes.draw do
  root to: redirect("/apipie")
  apipie

  resources :transaction_outputs
  resources :transaction_inputs
  resources :promotions

  resources :employees
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    namespace :admin do
      resources :categories
      resources :companies, only: [:index, :show]
      resources :users, only: [:index]
    end

    namespace :partner do
      resource :company, only: [:update, :show]
      resources :offices, only: [:index, :create, :show, :update]
    end
  end
end
