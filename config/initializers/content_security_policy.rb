# config/initializers/content_security_policy.rb
Rails.application.configure do
  config.content_security_policy do |policy|
    # Par défaut, on n’autorise que notre domaine
    policy.default_src :self
    policy.base_uri    :self

    # Polices / images (autorise nos assets + data: pour favicons/avatars)
    policy.font_src :self, :data
    # Si tu utilises des images distantes, garde :https
    policy.img_src  :self, :https, :data

    # Pas d’objets/plugins
    policy.object_src :none

    # JS/CSS servis depuis notre app (pas d'inline)
    policy.script_src :self
    policy.style_src  :self

    # Empêche l’inclusion du site dans des iframes externes
    policy.frame_ancestors :self
  end

  # Nonce pour d’éventuels scripts/styles inline (éviter d'en avoir)
  config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
  # Appliquer la politique (false = on bloque ; true = mode rapport uniquement)
  config.content_security_policy_report_only = false
end
