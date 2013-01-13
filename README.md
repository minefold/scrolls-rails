# scrolls-rails

## Usage

In `config/production.rb`:

    Scrolls::Rails.setup(Rails.application)
    config.middleware.delete Rails::Rack::Logger
    config.middleware.use Scrolls::Rails::Rack::QuietLogger
