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

  concern :commentable do
    member { post :create_comment }
  end
  
  resources :questions, concerns: %i[votable attachable commentable], defaults: { commentable: 'question' } do
    resources :answers, shallow: true, only: %i[create destroy update], concerns: %i[votable attachable commentable], defaults: { commentable: 'answer' } do
      patch :set_best, on: :member
    end
  end
end
