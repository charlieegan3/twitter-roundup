require_relative 'boot'

require 'rails/all'
require './lib/twitter_collector'
require './lib/webhook_notifier'
require './lib/email_notifier'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.roundup_account_limit = 10
    config.count_display_threshold = 15
  end
end
