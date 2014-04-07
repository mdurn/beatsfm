BeatsFm::Application.routes.draw do
  get "users/show"
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'home#index'

  namespace :users do
    get 'omniauth_callbacks/beats'
  end

  resources :users, only: [:show] do
  end

  get 'hitplay', to: 'users#show', as: :hitplay

  resource :api, only: [] do
    member do
      get :beats_artist_track, format: :json
      get :lastfm_recommend_artists, format: :json
    end
  end
end
