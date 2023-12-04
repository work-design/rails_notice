Rails.application.routes.draw do
  scope RailsCom.default_routes_scope do
    concern :notice do
      resources :notifications, only: [:index, :show, :destroy] do
        collection do
          get :readed
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

    namespace :notice, defaults: { business: 'notice' } do
      namespace :admin, defaults: { namespace: 'admin' } do
        root 'home#index'
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
            match :edit_user, via: [:get, :post]
            patch 'user' => :update_user
            match :edit_member, via: [:get, :post]
            get 'publish/options' => :options
            match :publish, via: [:get, :post]
          end
          resources :member_annunciates
        end
        resources :annunciates
      end

      namespace :me, defaults: { namespace: 'me' } do
        concerns :notice
      end

      namespace :my, defaults: { namespace: 'my' } do
        concerns :notice
      end
    end
  end
end
