Rails.application.routes.draw do

  get 'quizzes/new'

  get 'quizzes/show'

  get 'quizzes/create'

  get 'topics/show'

  get 'password_resets/new'
  get 'password_resets/edit'

  get 'sessions/new'

  root 'static_pages#home'


  
  get '/help', to: 'static_pages#help'
  get '/pending_approvals', to: 'questions#pending_approvals'
  get '/my_questions', to: 'questions#my_questions'
  get '/about', to: 'static_pages#about'
  get '/contacto', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  post '/signup',  to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  post 'quizzes/submit', to: 'quizzes#submit'
  get '/quizzes/:id/results', to: 'quizzes#results'
  get '/global_leaderboard', to: 'quizzes#global_leaderboard'

  get 'questions/:id/approve', to: 'questions#new_approval'
  patch 'questions/:id/approve', to: 'questions#approve'

  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :topics
  resources :topic_followers, only: [:create, :destroy]
  resources :quizzes
  resources :questions, only: [:new, :create, :update, :approve]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root 'static_pages#home'
end
