Rails.application.routes.draw do
    root to: 'accounts#index'
    resources :accounts, only: [:index, :create, :new] do
        member do
            get '/aaa', to: 'accounts#aaa'
        end
        collection do
            post '/bbb', to: 'accounts#bbb'
        end
    end
end
