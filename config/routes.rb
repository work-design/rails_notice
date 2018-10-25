Rails.application.routes.draw do

  scope :admin, module: 'notice/admin', as: 'admin' do
    resources :notifications do
      patch :push, on: :member
      patch :email, on: :member
    end
    resources :notify_settings do
      get :columns, on: :collection
    end
    resources :notification_settings
  end

  scope module: 'notice/my' do
    resources :notifications, only: [:index, :show, :destroy] do
      get :read_all, on: :collection
      get :url, on: :member
      get :read, on: :member
    end
    resource :notification_settings, only: [:show, :edit, :update]
  end

  scope :api, module: 'notice/api', as: :api do
    resources :notifications, only: [:index, :show, :destroy] do
      get :read_all, on: :collection
      get :url, on: :member
      get :read, on: :member
    end
    resource :notification_settings, only: [:show, :edit, :update]
  end

  resources :receivers do
    get :search, on: :collection
  end

  mount ActionCable.server => '/cable'

end
