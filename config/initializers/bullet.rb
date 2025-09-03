# config/initializers/bullet.rb
if Rails.env.development?
  Rails.application.configure do
    config.after_initialize do
      Bullet.enable        = true
      Bullet.bullet_logger = true      # log dans log/bullet.log
      Bullet.rails_logger  = true      # log dans la console Rails
      # Bullet.alert      = true      # popups dans le navigateur (optionnel)
      # Bullet.add_footer = true      # bannière en bas de page (optionnel)

      # Conseils supplémentaires
      Bullet.unused_eager_loading_enable = true
      Bullet.counter_cache_enable        = true
    end
  end
end
