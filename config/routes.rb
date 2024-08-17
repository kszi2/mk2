Rails.application.routes.draw do
  get 'students/import' => 'students#import', as: :import_students
  post 'students/bulk_create' => 'students#bulk_create', as: :bulk_create_students
  resources :students
  resources :courseworks
  resources :groups
  resources :templates
  resources :courses
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "courses#index"
end
