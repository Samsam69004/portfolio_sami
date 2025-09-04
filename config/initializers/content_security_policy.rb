# config/initializers/content_security_policy.rb
Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.base_uri    :self

    # Scripts (Hotjar + GA4)
    policy.script_src  :self, :https,
      "https://static.hotjar.com", "https://script.hotjar.com",
      "https://www.googletagmanager.com",
      "https://www.google-analytics.com"

    # XHR/WebSocket (Hotjar + GA4)
    policy.connect_src :self, :https,
      "https://*.hotjar.com", "https://*.hotjar.io",
      "wss://*.hotjar.com",  "wss://*.hotjar.io",
      "https://*.google-analytics.com",
      "https://stats.g.doubleclick.net"

    # Images (incl. data: pour favicons & pixels)
    policy.img_src :self, :https, :data,
      "https://*.hotjar.com", "https://*.hotjar.io",
      "https://*.google-analytics.com",
      "https://*.g.doubleclick.net"

    # Fonts/CSS locaux (✅ ajouter les deux lignes suivantes UNIQUEMENT si tu utilises Google Fonts)
    policy.font_src  :self, :data # , "https://fonts.gstatic.com"
    policy.style_src :self        # , "https://fonts.googleapis.com"

    # iframes autorisées depuis TON site (PDF, etc.)
    policy.frame_src :self, :https
    policy.child_src :self

    policy.object_src :none
    policy.frame_ancestors :self
  end

  # Nonces pour <script>/<style> inline signés
  config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
  config.content_security_policy_report_only = false
end
