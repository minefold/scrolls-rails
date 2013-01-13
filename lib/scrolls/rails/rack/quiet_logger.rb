require 'rails/rack/logger'
require 'active_support/log_subscriber'

module Scrolls
  module Rails
    module Rack
      class QuietLogger < ::Rails::Rack::Logger

        def call_app(request, env)
          @app.call(env)
        ensure
          ActiveSupport::LogSubscriber.flush_all!
        end

      end
    end
  end
end
