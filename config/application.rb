require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Crm
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

LetterAvatar.setup do |config|
  config.fill_color        = 'rgba(255, 255, 255, 1)' # default is 'rgba(255, 255, 255, 0.65)'
  config.cache_base_path   = 'public/system/' # default is 'public/system'
  config.colors_palette    = :iwanthue                # default is :google
  config.weight            = 500                      # default is 300
  config.annotate_position = '-0+10'                  # default is -0+5
end

Rails.application.configure do
  config.time_zone = "Kuala Lumpur"
  config.active_record.default_timezone = :local
end
