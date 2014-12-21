Rails.application.routes.draw do
  root 'jobs#index'

  get '/auth/github/callback', to: 'sessions#create'
  delete '/sign_out', to: 'sessions#destroy'
  get '/sign_out', to: 'sessions#destroy' if Rails.env.test?

  get '/about', to: 'static_pages#about'

  resources :jobs, only: [:index, :new]
end
