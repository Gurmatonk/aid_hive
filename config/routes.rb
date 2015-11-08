Rails.application.routes.draw do
  root to: 'visitors#index'

  devise_for :users
  resources :users

  resources :requests do
    collection do
      get :my
    end
  end
end
