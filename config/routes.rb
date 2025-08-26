# config/routes.rb
Rails.application.routes.draw do
  get "contacts/new"
  get "contacts/create"
  # Accueil
  root "projects#index"

  # Projets (slug au lieu d'id)
  resources :projects, only: [ :index, :show ], param: :slug

  # Contact propre : /contact (GET) pour le formulaire, /contact (POST) pour l'envoi
  get  "/contact", to: "contacts#new",    as: :contact
  post "/contact", to: "contacts#create"

  # Health & PWA (si utilisés)
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
