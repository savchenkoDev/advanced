Rails.application.routes.draw do
  devise_for :users

  root to: "questions#index"
  patch '/set_best/:id', to: 'answers#set_best', as: 'set_best'
  resources :questions do
    resources :answers, shallow: true, only: %i[create destroy update]
  end
end
