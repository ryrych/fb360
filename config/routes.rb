Rails.application.routes.draw do
  devise_for :users
  root to: 'home#show'

  namespace :admin do
    resource :present_feedback, only: :show, controller: :present_feedback
    resource :publish_feedback, only: [:show, :update], controller: :publish_feedback
    resources :users, only: [:new, :create, :index, :edit, :update] do
      resource :reset_password, only: :update, controller: :reset_password
    end
  end

  namespace :user do
    resources :feedbacks, only: [:new, :create, :index, :edit, :update, :destroy]
    resource :profile, controller: :profile, only: [:edit, :update]
  end
end
