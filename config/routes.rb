Rails.application.routes.draw do
  # Devise authentication
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  namespace :admin do
    get "bookings/index"
    get "bookings/show"
    get "bookings/refund"
    get "bookings/payout"

    resources :bookings, only: [:index, :show] do
      member do
        post :refund
        post :payout
      end
    end
  end

  # Contact owner about a car
  get "owners/:id/contact", to: "owners#contact", as: :contact_owner

  # Terms page
  get "terms", to: "pages#terms", as: :terms

  # Root path
  root "pages#landing"

  # M-Pesa callbacks
 # M‑Pesa STK Push callbacks (both deposit and final use the same action)
post "/mpesa/deposit_callback", to: "mpesa_callbacks#payment_callback"
post "/mpesa/final_payment_callback", to: "mpesa_callbacks#payment_callback"

# B2C payout callbacks
post "/mpesa/result_callback",  to: "mpesa_callbacks#result_callback"
post "/mpesa/timeout_callback", to: "mpesa_callbacks#timeout_callback"

  # M-Pesa callbacks (sandbox-friendly paths)
  #post "/payment/payment_callback", to: "mpesa#callback"
  #post "/payment/deposit_callback", to: "mpesa#deposit_callback"
  #post "/payment/result_callback",  to: "mpesa#result_callback"
  #post "/payment/timeout_callback", to: "mpesa#timeout_callback"

  # Cars
  resources :cars do
    resources :reviews, only: [:create]
    resources :bookings, only: [:new, :create]

    member do
      delete 'purge_image/:image_id', to: 'cars#purge_image', as: 'purge_image'
    end

    collection do
      get :search
    end
  end

  # Favorites
  resources :favorites, only: [:create, :destroy]

  # Dashboards
  get 'renter_dashboard', to: 'bookings#renter_dashboard', as: :renter_dashboard
  get 'owner_dashboard',  to: 'bookings#owner_dashboard',  as: :owner_dashboard

  # Bookings + nested viewings
  resources :bookings do
    resources :viewings, only: [:new, :create]

    member do
      post   :pay
      post   :pay_deposit
      patch  :approve
      patch  :reject
      patch  :start_timer
      patch  :stop_timer
      get    :edit_invoice
      patch  :update_invoice
      post   :finalize_invoice
      get    :booking_actions
    end
  end

  # Purchases
  resources :purchases do
    member do
      patch :approve
      patch :reject
      patch :cancel
    end
  end

  # Health check
  get "up", to: "rails/health#show", as: :rails_health_check
end
