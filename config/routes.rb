Rails.application.routes.draw do
  root to: 'visitors#index'

  mount Commontator::Engine => '/commontator'

  devise_for :users
  resources :users

  resources :requests do
    collection do
      get :my
    end
  end

  resources :offers do
    collection do
      get :my
    end
  end
end
