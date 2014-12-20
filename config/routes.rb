Rails.application.routes.draw do
  root 'home#index'

  get '/auth/github/callback', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
end
