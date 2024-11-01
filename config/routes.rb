Rails.application.routes.draw do
  root "application#home"
  get '/*a', to: 'application#not_found'

  post '/auth/login', to: 'authentication#login'
  delete '/auth/logout', to: 'authentication#logout'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
