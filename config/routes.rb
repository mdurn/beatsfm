BeatsFm::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'home#index'

  namespace :users do
    get 'omniauth_callbacks/beats'
  end
end
