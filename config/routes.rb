Rails.application.routes.draw do
  devise_for :users
  root to: 'home#show'

  namespace :admin do
    resource :publish_feedback, only: [:show, :update], controller: :publish_feedback
    resources :users, only: [:new, :create, :index, :edit, :update]
  end

  namespace :user do
    resources :browse_feedback, only: :index
    resources :feedbacks, only: [:new, :create, :index, :edit, :update, :destroy]
    resource :profile, controller: :profile, only: [:edit, :update]
  end

  resource :home, only: :show, controller: :home
end
