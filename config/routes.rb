Rails.application.routes.draw do

  scope :admin, module: 'notice/admin', as: :admin do
    resources :notifications do
      patch :push, on: :member
      patch :email, on: :member
    end
    resources :notify_settings do
      get :columns, on: :collection
    end
    resources :notification_settings
    resources :annunciations do
      member do
        get 'publish' => :edit_publish
        patch 'publish' => :update_publish
        get 'publish/options' => :options
        patch :wechat
      end
    end
  end

  scope :my, module: 'notice/my', as: :my do
    resources :notifications, only: [:index, :show, :destroy] do
      get :read_all, on: :collection
      member do
        get :url
        get :read
        patch :archive
      end
    end
    resource :notification_setting, only: [:show, :edit, :update]
  end

  resources :receivers do
    get :search, on: :collection
  end
  
end
