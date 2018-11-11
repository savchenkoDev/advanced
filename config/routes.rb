require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resources :users do
    get :edit_email
    patch :update_email
  end

  root to: "questions#index"

  mount ActionCable.server => '/cable'
  
  concern :votable do
    member do
      patch :like
      patch :dislike
      delete :destroy_vote
    end
  end

  concern :attachable do
    resources :attachments, shallow: true, only: %i[destroy]
  end

  concern :commentable do
    member { post :create_comment }
  end
  
  resources :questions, concerns: %i[votable attachable commentable], defaults: { commentable: 'question' } do
    resources :answers, shallow: true, only: %i[create destroy update], concerns: %i[votable attachable commentable], defaults: { commentable: 'answer' } do
      patch :set_best, on: :member
    end

    resources :subscriptions, only: %i[create destroy], shallow: true
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create], shallow: true do
        resources :answers, only: %i[index show create]
      end
    end
  end
end
