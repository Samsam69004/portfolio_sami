# config/environments/development.rb
require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Reload à chaud en dev
  config.enable_reloading = true

  # Pas de eager load au boot
  config.eager_load = false

  # Affiche les erreurs complètes
  config.consider_all_requests_local = true

  # Server-Timing
  config.server_timing = true

  # Caching (rails dev:cache pour toggle)
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # Active Storage
  config.active_storage.service = :local

  # --- Mailer : envoi réel via SMTP (Gmail) en DEV ---
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries    = true
  config.action_mailer.delivery_method       = :smtp

  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    user_name:            Rails.application.credentials.dig(:gmail, :user),
    password:             Rails.application.credentials.dig(:gmail, :app_password),
    authentication:       "plain",
    enable_starttls_auto: true,
    open_timeout:         5,
    read_timeout:         5
  }

  # URLs générées dans les mails
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

  # Dépréciations
  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  # Erreur si migrations en attente
  config.active_record.migration_error = :page_load

  # Logs plus verbeux sur SQL/Jobs
  config.active_record.verbose_query_logs = true
  config.active_job.verbose_enqueue_logs = true

  # Silence les logs d’assets
  config.assets.quiet = true

  # Annoter les vues avec leurs chemins
  config.action_view.annotate_rendered_view_with_filenames = true

  # Autoriser une erreur si before_action cible une action inexistante
  config.action_controller.raise_on_missing_callback_actions = true

  # # Si besoin d’ouvrir Action Cable à toutes origines (décommenter si utile)
  # config.action_cable.disable_request_forgery_protection = true

  # # Appliquer auto-correction RuboCop après les generators (optionnel)
  # config.generators.apply_rubocop_autocorrect_after_generate!
end
