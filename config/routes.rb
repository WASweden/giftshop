Rails.application.routes.draw do


  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'orders#new'

  get 'om',       to: 'pages#info', as: :info
  get 'hjalp',    to: 'pages#help', as: :help
  get 'integritetspolicy', to: 'pages#integritetspolicy', as: :integritetspolicy

  get 'dev-card', to: 'pages#dev_card', as: :dev_card
  get 'card-private-standard', to: 'pages#card_private_standard', as: :card_private_standard
  get 'card-private-xmas', to: 'pages#card_private_xmas', as: :card_private_xmas
  get 'card-business-standard', to: 'pages#card_business_standard', as: :card_business_standard
  get 'card-business-standard-en', to: 'pages#card_business_standard_en', as: :card_business_standard_en
  get 'card-business-xmas', to: 'pages#card_business_xmas', as: :card_business_xmas
  get 'dev-design', to: 'pages#dev_design', as: :dev_design

  get 'sms-order/jAuEhzn193', to: 'sms#new'
  get 'sms-order/s87sMxefrw', to: 'sms#new_xmas'
  get 'sms-order/Ksa812jDjb', to: 'sms#new_small'
  get 'sms-order/f12bnffG1A', to: 'sms#new_xmas_small'

  resources :giftcards

  get 'foretag2', to: 'giftcards#foretag'

  namespace :company, path: 'foretag' do
    get '/', to: 'orders#new'
    resources :orders, only: [:show, :update]
    resources :order_items, only: [:create, :destroy]
  end

  resources :persons, only: [:create]

  scope path_names: { new: 'skapa', edit: 'redigera' } do
    resources :cards, :digital_cards, :analog_cards, path: 'gavobevis', except: [:new] do
      get 'bekrafta', action: :confirmation, on: :member, as: :confirmation
      get 'forhandsgranska', action: :preview, on: :member, as: :preview
    end

    resources :orders, only: [:show, :update]
    resources :order_items, only: [:create, :destroy]

    resource :cart, path: 'varukorg', only: [:show, :update]
    resource :checkout, path: 'checkout', path_names: { new: '' }, only: [:new] do
      get 'complete', action: :complete, as: :complete
      get 'swish', action: :swish, as: :swish
      post 'charge', action: :charge, as: :charge
      get 'swish_payment_status'
    end

    scope module: 'customer' do
      resources :customers, path: 'kund' do
        resources :cards, path: 'gavobevis', only: [:edit, :update] do
          get 'forhandsgranska', action: :preview, on: :member, as: :preview
        end
      end
    end
  end

  ##########################################
  # Service callbacks
  ##########################################
  scope '/callbacks' do
    post 'stripe', to: 'callbacks#stripe'
    post 'swish', to: 'callbacks#swish'
  end

  ##########################################
  # Sidekiq
  ##########################################
  require 'sidekiq/web'
  authenticate :admin_user do
    mount Sidekiq::Web => '/sidekiq'
  end
end
