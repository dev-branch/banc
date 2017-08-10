Rails.application.routes.draw do
    root to: 'accounts#index'
    resources :accounts, only: [:index, :new, :create] do
        member do
            get '/transactions', to: 'accounts#transactions'
            get '/atm', to: 'accounts#atm'
            post '/deposit', to: 'accounts#deposit'
            post '/withdraw', to: 'accounts#withdraw'
            post '/clear', to: 'accounts#clear'
        end
    end
end
