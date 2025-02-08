Rails.application.routes.draw do
  get "index/index"
  devise_for :users
  apipie
  mount GoodJob::Engine => 'good_job'
  if Rails.env.development?
    mount Lookbook::Engine => "lookbook"
  end

  get 'control_panel' => 'control_panel#view', as: :control_panel

  get 'users/_self' => 'users#self_user', as: :self_user
  resources :users do
    get 'edit_password' => 'users#edit_password', as: :edit_password
    post 'update_password' => 'users#update_password', as: :update_password
  end

  get 'students/import' => 'students#import', as: :import_students
  post 'students/bulk_create' => 'students#bulk_create', as: :bulk_create_students
  resources :students

  resources :free_days
  resources :courses do
    resources :course_types
    resources :courseworks do
      post "reorder" => "courseworks#reorder", as: :reorder_ratings
      resources :rating_points
    end

    resources :groups do
      post "send_attendance" => "groups#send_attendance", as: :send_attendance

      # get "add_students", to: "groups#add_students", as: :add_students
      post "add_students", to: "groups#add_students", as: :add_students
      post "prepare_students", to: "groups#prepare_students", as: :prepare_students

      get "teachers", to: "groups#add_teacher", as: :teachers
      post "teachers", to: "groups#associate_teacher"
      delete "teachers/:id", to: "groups#remove_teacher", as: :remove_teacher

      delete ":neptun", to: "groups#remove_student", as: :remove_student

      get "submissions/filter_for" => "submissions#filter_for", as: :filter_for
      resources :submissions do
        resources :marked_points, only: :index do
          post 'make_marking', to: 'marking_notes#make_marking', as: :make_marking
          post 'cancel_make', to: 'marking_notes#cancel_make', as: :cancel_make

          resources :marking_notes do
            post 'toggle', to: 'marking_notes#toggle', as: :toggle
          end
        end
      end
    end
  end
  resources :templates

  resources :rating_styles
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "index#index"
end
