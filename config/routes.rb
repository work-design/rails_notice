Rails.application.routes.draw do

  scope 'notice/admin', module: 'notice/admin', defaults: { business: 'notice', namespace: 'admin' } do
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
    resources :users
    resources :members
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

  scope :me, module: 'notice/me', as: :me, defaults: { business: 'notice', namespace: 'me' } do
    resources :notifications, only: [:index, :show, :destroy] do
      collection do
        post :read_all
      end
      member do
        get :url
        patch :read
        match :archive, via: [:put, :patch]
      end
    end
    resource :notification_setting, only: [:show, :edit, :update]
  end

  scope :my, module: 'notice/my', as: :my, defaults: { business: 'notice', namespace: 'my' } do
    resources :notifications, only: [:index, :show, :destroy] do
      collection do
        post :read_all
      end
      member do
        get :url
        patch :read
        match :archive, via: [:put, :patch]
      end
    end
    resource :notification_setting, only: [:show, :edit, :update]
  end

end
