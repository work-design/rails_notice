Rails.application.routes.draw do

  namespace :admin do
    resources :notifications do
      patch 'push', on: :member
    end
  end

end
