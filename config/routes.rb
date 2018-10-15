Rails.application.routes.draw do
  devise_for :users

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
  
  resources :questions, concerns: %i[votable attachable] do
    resources :answers, shallow: true, only: %i[create destroy update], concerns: %i[votable attachable] do
      patch :set_best, on: :member
    end
  end
end
