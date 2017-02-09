Rails.application.routes.draw do

  namespace :admin do
    resources :notifications do
      patch 'push', on: :member
    end
  end
  resources :notifications do
    get 'url', on: :member
    get 'read', on: :member
    get 'read_all', on: :collection
  end
  resource :notification_settings, only: [:show, :edit, :update]

  mount ActionCable.server => '/cable'

end
