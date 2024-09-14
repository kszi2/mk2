require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mk2
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # use good_job in all scenarios (good_job itself handles different envs)
    config.active_job.queue_adapter = :good_job
    config.good_job.enable_cron = true
    config.good_job.cron = {
      # send_next_days_attendances: {
      #   cron: "29 17 * * *",
      #   class: 'DailySendNeededAttendancesJob',
      # },
      send_next_week_attendances: {
        cron: "17 19 * * 0",
        class: 'WeeklySendNeededAttendancesJob'
      }
    }
  end
end
