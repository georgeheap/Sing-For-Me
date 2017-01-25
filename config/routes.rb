Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/songs/data', as: :data

  resources :songs, only: [:index, :show]


end
