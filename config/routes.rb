Rails.application.routes.draw do

  scope :admin, module: 'notice/admin', as: :admin do
    resources :notifications do
      member do
        patch :push
        patch :email
      end
    end
    resources :notify_settings do
      collection do
        get :columns
      end
    end
    resources :notification_settings
    resources :annunciations do
      member do
        get 'user' => :edit_user
        patch 'user' => :update_user
        get 'member' => :edit_member
        patch 'member' => :update_member
        get 'publish/options' => :options
      end
    end
    resources :annunciates
  end

  scope :me, module: 'notice/me', as: :me do
    resources :notifications, only: [:index, :show, :destroy] do
      collection do
        get :read_all
      end
      member do
        get :url
        get :read
        match :archive, via: [:put, :patch]
      end
    end
    resource :notification_setting, only: [:show, :edit, :update]
  end

  scope :my, module: 'notice/my', as: :my do
    resources :notifications, only: [:index, :show, :destroy] do
      collection do
        get :read_all
      end
      member do
        get :url
        get :read
        match :archive, via: [:put, :patch]
      end
    end
    resource :notification_setting, only: [:show, :edit, :update]
  end

end
