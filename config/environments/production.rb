require "active_support/core_ext/integer/time"

Rails.application.configure do
  # --- Core ---
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Déchiffrement des credentials en prod
  config.require_master_key = true

  # --- Assets / fichiers statiques ---
  config.assets.compile = true
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # --- Active Storage ---
  config.active_storage.service = :local  # (sur Heroku, stockage éphémère)

  # --- HTTPS & sécurité ---
  config.force_ssl = true
  config.ssl_options = { hsts: { expires: 1.year, preload: true, subdomains: true } }

  # --- Logs ---
  logger = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = ::Logger::Formatter.new
  config.logger = ActiveSupport::TaggedLogging.new(logger)
  config.log_tags  = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # --- I18n / divers ---
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [ :id ]

  # --- Action Mailer (SMTP Gmail) ---
  config.action_mailer.perform_caching       = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries    = true

  config.action_mailer.default_url_options = {
    host: ENV.fetch("MAILER_HOST", "portfolio-sami.herokuapp.com"),
    protocol: "https"
  }
  config.action_mailer.asset_host = "https://#{ENV.fetch("MAILER_HOST", "portfolio-sami.herokuapp.com")}"

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    user_name:            Rails.application.credentials.dig(:gmail, :user),
    password:             Rails.application.credentials.dig(:gmail, :app_password),
    authentication:       "plain",
    enable_starttls_auto: true
  }

  # --- Hosts autorisés ---
  config.hosts << ENV["MAILER_HOST"] if ENV["MAILER_HOST"].present?
  config.hosts << "www.ton-domaine.fr"
  config.hosts << "ton-domaine.fr"
  config.hosts << "portfolio-sami.herokuapp.com"
  # Autorise uniquement ton domaine Heroku
  config.hosts << "portfolio-sami-b5f77d3264a1.herokuapp.com"
  # Autoriser *.herokuapp.com + ton host d’env
  config.hosts << /.*\.herokuapp\.com/
  config.hosts << ENV["MAILER_HOST"] if ENV["MAILER_HOST"].present?
end
