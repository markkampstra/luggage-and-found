Rails.application.routes.draw do
  resources :luggage_tags do
    member do
      get :public
      post :report_missing
      match :report_found, via: [:get, :patch]
      post :report_ok
      get :qr
    end
  end
  devise_for :users
  root to: 'home#index'
end
