require_relative 'boot'

require "rails"

require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module TaxiBackend
  class Application < Rails::Application
    config.load_defaults 5.1
    config.api_only = false
    config.eager_load_paths << Rails.root.join('lib')
    config.active_job.queue_adapter = :sidekiq
    config.i18n.default_locale = :ru
    config.time_zone = 'Moscow'

    config.action_cable.mount_path = '/api/v1/cable'
    config.action_cable.disable_request_forgery_protection = true
  end
end
