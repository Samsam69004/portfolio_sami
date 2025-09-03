# config/initializers/content_security_policy.rb
Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.base_uri    :self

    # 🔐 Scripts: notre domaine + Hotjar (+ https)
    policy.script_src  :self, :https, "https://static.hotjar.com", "https://script.hotjar.com"

    # 🔌 Requêtes XHR/WebSocket pour Hotjar
    policy.connect_src :self, :https, "https://*.hotjar.com", "https://*.hotjar.io",
                                 "wss://*.hotjar.com",  "wss://*.hotjar.io"

    # 🖼️ Images (y compris data: pour favicons, Hotjar)
    policy.img_src     :self, :https, :data, "https://*.hotjar.com", "https://*.hotjar.io"

    # 🅰️ Fonts/CSS locaux
    policy.font_src    :self, :data
    policy.style_src   :self

    # Pas d’objets/plugins
    policy.object_src  :none

    # Empêche l’inclusion de TON site dans des iframes externes
    policy.frame_ancestors :self
  end

  # ✅ Active un nonce pour autoriser les <script> inline signés
  config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
  config.content_security_policy_report_only = false
end
