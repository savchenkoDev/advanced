require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Advanced
  class Application < Rails::Application
    # Use Redis for caching
    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }

    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.action_cable.disable_request_forgery_protection = false

    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_spec: true,
                       controller_spec: true,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
  end
end
