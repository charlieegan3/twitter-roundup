Rails.application.routes.draw do
  root 'application#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :roundups do
    post :refresh, on: :member
  end
end
