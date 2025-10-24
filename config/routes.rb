Rails.application.routes.draw do
  get "dashboard/index"
  get "dashboard/ingresos"
  post "dashboard/ingresos", to: "dashboard#ingresos"
  post "dashboard/guardar_pago", to: "dashboard#guardar_pago", as: :dashboard_guardar_pago
  resources :estudiantes, only: [:update, :destroy]
  resources :pagos, only: [:update, :destroy]
  get "dashboard/consultas"
  get "dashboard/control_usuarios"
  get "dashboard/buscar_estudiantes", to: "dashboard#buscar_estudiantes"
  post "dashboard/guardar_asignacion", to: "dashboard#guardar_asignacion", as: :dashboard_guardar_asignacion
  post "dashboard/guardar_curso", to: "dashboard#guardar_curso", as: :dashboard_guardar_curso
  post "dashboard/guardar_profesor", to: "dashboard#guardar_profesor", as: :dashboard_guardar_profesor
  post "dashboard/guardar_usuario", to: "dashboard#guardar_usuario", as: :dashboard_guardar_usuario
  resources :asignacion_cursos, only: [:update, :destroy, :show]
  resources :cursos, only: [:update, :destroy]
  resources :profesores, only: [:update, :destroy]
  resources :usuarios, only: [:update, :destroy]
  
  root "home#index"

  # Rutas de login/logout
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Dashboard
  get "/dashboard", to: "dashboard#index"
  get "/dashboard/ingresos", to: "dashboard#ingresos"
  get "/dashboard/consultas", to: "dashboard#consultas"
  get "/dashboard/control_usuarios", to: "dashboard#control_usuarios"

  get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
