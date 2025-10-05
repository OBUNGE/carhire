Rails.application.routes.draw do
  # =========================
  # Devise authentication
  # =========================
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # =========================
  # Admin namespace
  # =========================
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

  # =========================
  # Public pages
  # =========================
  get "owners/:id/contact", to: "owners#contact", as: :contact_owner
  get "terms", to: "pages#terms", as: :terms
  root "pages#landing"

  # =========================
  # Payment callbacks (Daraja)
  # =========================
  # STK Push (deposit + final handled via AccountReference)
  post "/payment/stk_callback",     to: "mpesa_callbacks#payment_callback"

  # B2C payout callbacks
  post "/payment/result_callback",  to: "mpesa_callbacks#result_callback"
  post "/payment/timeout_callback", to: "mpesa_callbacks#timeout_callback"

  # Refund callbacks (if you’re supporting refunds)
  post "/payment/refund_result_callback",  to: "mpesa_callbacks#refund_result_callback"
  post "/payment/refund_timeout_callback", to: "mpesa_callbacks#refund_timeout_callback"

  # =========================
  # Cars
  # =========================
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

  # =========================
  # Favorites
  # =========================
  resources :favorites, only: [:create, :destroy]

  # =========================
  # Dashboards
  # =========================
  get 'renter_dashboard', to: 'bookings#renter_dashboard', as: :renter_dashboard
  get 'owner_dashboard',  to: 'bookings#owner_dashboard',  as: :owner_dashboard

  # =========================
  # Bookings + nested viewings
  # =========================
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

  # =========================
  # Purchases
  # =========================
  resources :purchases do
    member do
      patch :approve
      patch :reject
      patch :cancel
    end
  end

  # =========================
  # Health check
  # =========================
  get "up", to: "rails/health#show", as: :rails_health_check
end
