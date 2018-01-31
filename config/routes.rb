require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  scope "dispatcher" do
    devise_for :dispatcher_admin_users, ActiveAdmin::Devise.config
  end
  scope "senior_dispatcher" do
    devise_for :senior_dispatcher_admin_users, ActiveAdmin::Devise.config
  end
  ActiveAdmin.routes(self)
  mount ActionCable.server => '/api/v1/cable'

  namespace :admin do
    authenticate :admin_user, -> (u) { u.is_a? AdminUser } do
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :tariffs, only: [:index]
      resources :order_options, only: [:index]
      resource :price_setting, only: [:show]

      resources :drivers, only: [:show, :update] do
        post 'initialization', on: :member
        put 'remove_image', on: :member
      end

      resources :users, only: [:show, :update] do
        post 'initialization', on: :member
        get 'near_drivers', on: :member
        put 'remove_image', on: :member
        post 'bind_card', on: :member
        post 'accept_payment', on: :collection
        delete 'remove_card', on: :member
        get 'cards', on: :member
        post 'close_debt', on: :member
      end

      namespace :drivers do
        post 'auth' => 'authentication#authenticate_driver'
        post 'send_password' => 'authentication#send_password'
      end

      namespace :users do
        post 'auth' => 'authentication#authenticate_user'
        post 'send_password' => 'authentication#send_password'
      end

      resources :orders, only: [:index, :create, :show, :destroy] do
        put 'wait', on: :member
        put 'start', on: :member
        put 'take', on: :member
        put 'close', on: :member
        put 'estimate', on: :member
        get 'preliminary', on: :collection
      end

      resource :synchronization, controller: :synchronization, only: [:create]
      resource :coordinates, only: [:show]
      resource :addresses, only: [:show] do
        get 'autocomplete'
      end
      resource :routes, only: [:show]
    end
  end

  scope :payment do
    controller 'cloud_payments' do
      post :pay
      post :fail
      post :recurrent
    end
  end
end
