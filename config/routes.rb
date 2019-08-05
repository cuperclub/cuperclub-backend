Rails.application.routes.draw do
  root to: redirect("/apipie")
  apipie

  resources :transaction_outputs
  resources :transaction_inputs

  # mount_devise_token_auth_for 'User', at: 'auth'

  mount_devise_token_auth_for(
    "User",
    at: "auth",
    controllers: {
      sessions: "auth/sessions",
      registrations: "auth/registrations",
      passwords: "auth/passwords",
      token_validations: "auth/token_validations"
    }
  )

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do

    resources :companies, only: [:index]
    resources :promotions, only: [:index, :show]
    resource :users, only: [:update] do
      member do
        put :current_view
      end
    end
    resources :users, only: [:update, :index]
    match "users/search" => 'users#search', via: :get

    namespace :admin do
      resources :categories
      resources :companies, only: [:index, :show] do
        member do
          put :change_status
        end
      end
      resources :users do
        member do
          put :toggle_status
          put :update_password
        end
        collection do
          get "/:role",
              to: "users#index"
        end
      end
    end

    namespace :partner do
      resource :companies, only: [:create, :update, :show] do
        resources :promotions, only: [:index, :show] do
          member do
            get :transaction_outputs
          end
        end
        resources :offices, only: [:index, :create, :show, :update] do
          member do
            put :toggle_status
          end
          resources :promotions, only: [:create, :update]
        end
        resources :employees, only: [:index, :show] do
          member do
            put :update_state
          end
        end
      end
    end

    namespace :cashier do
      resource :profile, only: [:create]
    end

    resources :transaction_inputs, only: [:index, :create]
    resources :transaction_outputs, only: [:index, :create]
  end
end
