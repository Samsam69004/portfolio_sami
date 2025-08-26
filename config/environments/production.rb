require "active_support/core_ext/integer/time"

Rails.application.configure do
  # --- Core ---
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Déchiffrement des credentials en prod (recommandé)
  # -> mets RAILS_MASTER_KEY sur ton hébergeur
  # config.require_master_key = true

  # --- Assets / fichiers statiques ---
  # Laisse à false si ton reverse proxy sert les fichiers ; sinon active via variable.
  config.assets.compile = false
  # Permettre à Rails de servir les fichiers statiques si RAILS_SERVE_STATIC_FILES=1
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # --- Active Storage ---
  config.active_storage.service = :local

  # --- HTTPS & sécurité ---
  config.force_ssl = true
  config.ssl_options = { hsts: { expires: 1.year, preload: true, subdomains: true } }

  # --- Logs ---
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |l| l.formatter = ::Logger::Formatter.new }
    .then { |l| ActiveSupport::TaggedLogging.new(l) }
  config.log_tags  = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # --- I18n / divers ---
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [ :id ]

  # --- Action Mailer (SMTP Gmail) ---
  config.action_mailer.perform_caching     = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries    = true

  # ⚠️ Remplace par le domaine de ton site déployé
  config.action_mailer.default_url_options = { host: "www.ton-domaine.fr", protocol: "https" }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    user_name:            Rails.application.credentials.dig(:gmail, :user),
    password:             Rails.application.credentials.dig(:gmail, :app_password),
    authentication:       "plain",
    enable_starttls_auto: true
  }

  # --- Hosts autorisés (évite Blocked host) ---
  # Remplace/duplique selon ton domaine / sous-domaines
  config.hosts << "www.ton-domaine.fr"
  config.hosts << "ton-domaine.fr"

  # # Health check si besoin
  # config.ssl_options = { redirect: { exclude: ->(r) { r.path == "/up" } } }
  # config.host_authorization = { exclude: ->(r) { r.path == "/up" } }
end
