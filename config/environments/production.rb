# config/environments/production.rb
require "active_support/core_ext/integer/time"

Rails.application.configure do
  # --- Core ---
  config.enable_reloading               = false
  config.eager_load                     = true
  config.consider_all_requests_local    = false
  config.action_controller.perform_caching = true

  # Déchiffrement des credentials en prod
  config.require_master_key = true

  # --- Assets / fichiers statiques ---
  # IMPORTANT: en prod, précompile hors-ligne et servez les assets compilés
  # (plus rapide et évite le fallback lent au runtime).
  config.assets.compile = false

  # Heroku définit RAILS_SERVE_STATIC_FILES=1 -> Rails sert /public
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # Cache long pour les assets fingerprintés
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.year.to_i}, immutable"
  }

  # --- Active Storage ---
  # Evite :local sur Heroku (stockage éphémère). Préfère S3/Cloudinary si possible.
  # config.active_storage.service = :amazon
  config.active_storage.service = :local

  # --- HTTPS & sécurité ---
  config.force_ssl = true
  config.ssl_options = { hsts: { expires: 1.year, preload: true, subdomains: true } }

  # En-têtes de sécurité supplémentaires (complément de ta CSP)
  config.action_dispatch.default_headers = {
    "X-Frame-Options" => "SAMEORIGIN",
    "X-Content-Type-Options" => "nosniff",
    "Referrer-Policy" => "strict-origin-when-cross-origin",
    "Permissions-Policy" => "camera=(), microphone=(), geolocation=()"
  }

  # --- Logs ---
  logger = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = ::Logger::Formatter.new
  config.logger    = ActiveSupport::TaggedLogging.new(logger)
  config.log_tags  = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # (Optionnel) logs plus compacts si tu utilises la gem 'lograge'
  # config.lograge.enabled = true

  # --- Cache store (recommandé : Redis si dispo) ---
  # config.cache_store = :redis_cache_store, { url: ENV["REDIS_URL"], compress: true, error_handler: ->(e, *) { Rails.logger.error(e) } }

  # --- I18n / divers ---
  config.i18n.fallbacks                        = true
  config.active_support.report_deprecations    = false
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect  = [ :id ]

  # --- Action Mailer (SMTP Gmail) ---
  config.action_mailer.perform_caching       = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries    = true

  app_host = ENV.fetch("MAILER_HOST", "portfolio-sami.herokuapp.com")

  config.action_mailer.default_url_options = {
    host: app_host,
    protocol: "https"
  }
  config.action_mailer.asset_host = "https://#{app_host}"

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    user_name:            Rails.application.credentials.dig(:gmail, :user),
    password:             Rails.application.credentials.dig(:gmail, :app_password),
    authentication:       "plain",
    enable_starttls_auto: true
  }

  # --- Hosts autorisés (nettoyé) ---
  # Autorise ton domaine principal + www, et ton app Heroku
  config.hosts.clear
  %w[
    samichabane.com
    www.samichabane.com
    portfolio-sami.herokuapp.com
    portfolio-sami-b5f77d3264a1.herokuapp.com
  ].each { |h| config.hosts << h }

  # Autoriser *.herokuapp.com (garde-le si tu fais du review-app)
  config.hosts << /.*\.herokuapp\.com/

  # Autoriser le host d'env si fourni
  config.hosts << ENV["MAILER_HOST"] if ENV["MAILER_HOST"].present?

  # --- Compression ---
  # Gzip côté Rack (Brotli conseillé via CDN/Proxy comme Cloudflare)
  config.middleware.use Rack::Deflater

  # (Optionnel) si tu sers derrière un CDN :
  # config.asset_host = ENV["ASSET_HOST"] # ex: https://cdn.samichabane.com
end
