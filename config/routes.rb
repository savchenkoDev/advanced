Rails.application.routes.draw do
  devise_for :users

  root to: "questions#index"
  
  concern :votable do
    patch :like, to: 'votes#like'
    patch :dislike, to: 'votes#dislike'
    resources :votes, only: :destroy, shallow: true
  end

  concern :attachable do
    resources :attachments, shallow: true, only: %i[destroy]
  end
  
  resources :questions, concerns: %i[votable attachable] do
    resources :answers, shallow: true, only: %i[create destroy update], concerns: :attachable do
      patch :set_best, on: :member
    end
  end
end
