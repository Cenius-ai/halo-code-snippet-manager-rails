require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Halo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # ── Secret key base (signing secret) ──────────────────────────────
    # Rails reads the master key from ENV["RAILS_MASTER_KEY"] to decrypt
    # config/credentials.yml.enc.  If the master key is unavailable or
    # credentials are missing we fall back to SECRET_KEY_BASE, then to
    # an ephemeral random so the app always boots in dev.
    config.secret_key_base = ENV.fetch("SECRET_KEY_BASE") {
      Rails.application.credentials.secret_key_base.presence ||
        (require "securerandom"; SecureRandom.hex(64))
    }

    # ── Non-signing config with a literal dev default ─────────────────
    # Example: the displayed application title.  Safe to hard-code a
    # clearly-dev literal so a fresh clone still boots with zero env.
    config.x.app_title = ENV.fetch("APP_TITLE", "Halo (dev)")

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
