Rails.application.routes.draw do
  # Accueil
  root "projects#index"

  # Projets (slug au lieu d'id)
  resources :projects, only: [:index, :show], param: :slug

  # Contact : /contact (GET) pour le formulaire, /contact (POST) pour l’envoi
  resource :contact, only: [:create], controller: :contacts
  get "/contact", to: "projects#index", as: :contact_page


  # Health & PWA
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
