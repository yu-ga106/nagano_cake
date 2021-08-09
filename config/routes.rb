Rails.application.routes.draw do
  devise_for :customers, :controllers => {
    :sessions => 'customers/sessions',
    :registrations => 'customers/registrations',
  }
  devise_for :admins, :controllers => {
    :sessions => 'admins/sessions',
    :registrations => 'admins/registrations',
  }
  #----------admin--------------
  namespace :admin do
    resources :customers, only: [:index, :show, :edit, :update]
    resources :items, only: [:index, :new, :create, :show, :edit, :update]
    get 'top' => 'items#top'
    get 'search' => 'items#search'
    resources :genres, only: [:index, :create, :edit, :update, :show, :destroy]
    resources :orders, only: [:index, :show, :update] do
      member do
        get :current_index
      end
    end
    resources :order_details, only: [:update]
  end
  #--------------------------------

  #----------customer--------------
  resource :customers, only: [:show, :new, :create, :edit, :update, :destroy] do
    member do
      get :quit
    end
  end

  #----------caddresses--------------
  resources :addresses, only: [:index, :edit, :create, :update, :destroy]

  resources :customers, only: [:destroy, :quit] do
    member do
      patch :out
    end
  end
  #----------items--------------
  root to: "items#top"
  get 'about' => 'items#about'
  get 'search' => 'items#search', as: 'genre_search'
  resources :items, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  #----------cart_items-----------------
  resources :cart_items, only: [:index, :create, :update, :destroy]
  get 'cart_items/all_destroy' => 'cart_items#all_destroy', as: 'all_destroy'

  get '/all_item' => 'cart_items#all_item'
  delete '/all_item' => 'cart_items#all_item'
  #--------------------------------

  #----------Orders-----------------
  resources :orders, only: [:new, :index, :show, :create] do
    collection do
      get 'log'
      post 'completed'
      get 'thanks'
    end
  end
  #--------------------------------
end