Rails.application.routes.draw do
  devise_for :users

  root to: "questions#index"
  
  resources :questions do
    resources :attachments, shallow: true, only: %i[destroy]
    resources :answers, shallow: true, only: %i[create destroy update] do
      resources :attachments, shallow: true, only: %i[destroy]
      patch :set_best, on: :member
    end
  end
end
