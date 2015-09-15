Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: 'users#index'
  get '/register', to: 'users#new'
  #add token following with register for click invitation mail's link
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'
  get 'expired_token', to: 'password_resets#expired_token'
  get 'people', to: 'relationships#index'
  get 'search', to: 'add_searched_words#search'
  post 'search', to: 'add_searched_words#search'
  get 'find_added_word', to: 'find_added_words#find_added_word'
  post 'find_added_word', to: 'find_added_words#find_added_word'
  get 'donate', to: 'donations#new'
  get 'users/:id/sort_by_created_date', to: 'users#sort_by_created_date', as: 'sort_by_created_date'
  get 'users/:id/sort_by_category', to: 'users#sort_by_category', as: 'sort_by_category'

  resources :users, only: [:create]
  resources :vocabularies, only: [:new, :create, :destroy, :edit, :update]
  resources :queue_items, only: [:create, :destroy]
  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:show, :create]
  resources :invitations, only: [:new, :create]
  resources :relationships, only: [:create, :destroy]
  resources :sessions, only: [:create]
  resources :categories, only: [:new, :create, :show]
  resources :add_searched_words, only: [:show, :create]
  resources :donations, only: [:create]
  resources :conversations, only: [:index, :show, :destroy] do
    member do
      post :reply
      post :restore
    end
    collection do
      delete :empty_trash
    end
  end
  resources :messages, only: [:new, :create]
  namespace :admin do
    resources :users, only: [:index, :destroy]
    resources :payments, only: [:index]
  end
  
  mount StripeEvent::Engine, at: '/stripe_events'
end
