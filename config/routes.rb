BeatsFm::Application.routes.draw do
  get "users/show"
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, skip: [:sessions]

  root 'home#index'

  as :user do
    get 'signin' => 'sessions#new', :as => :new_user_session
    post 'signin' => 'devise/sessions#create', :as => :user_session
    get 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

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
      get :lastfm_scrobble, format: :json
    end
  end
end
