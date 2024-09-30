Rails.application.routes.draw do
  root "application#home"

  get '/auth/me', to: 'authentication#me'
  post '/auth/login', to: 'authentication#login'
  post '/auth/logout', to: 'authentication#logout'
  patch '/auth/change-password', to: 'authentication#change_password'

  resources :users, param: :username, constraints: { username: /.+/ } do
    resource :profile, only: %i[show create update]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
