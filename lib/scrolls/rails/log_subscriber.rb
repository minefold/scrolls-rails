require 'scrolls'
require 'active_support/core_ext/class/attribute'
require 'active_support/log_subscriber'

module Scrolls
  module Rails
    class LogSubscriber < ActiveSupport::LogSubscriber

      FIELDS = [
        :method, :path, :format, :controller, :action, :status, :error,
        :duration, :view, :db, :location
      ]

      def process_action(event)
        exception = event.payload[:exception]

        if exception.present?
          if exception.is_a?(Array)
            exception_class_name, exception_message = exception
            exception = exception_class_name.constantize.new(exception_message)
          end

          Scrolls.log_exception({status: 500}, exception)
        else
          Scrolls.log(extract_request_data_from_event(event))
        end
      end

      def redirect_to(event)
        Thread.current[:scrolls_rails_location] = event.payload[:location]
      end

    # private

      def extract_request_data_from_event(event)
        data = extract_request(event.payload)
        data[:status] = extract_status(event.payload)
        data.merge! runtimes(event)
        data.merge! location(event)
      end

      def extract_request(payload)
        {
          :method => payload[:method],
          :path => payload[:path],
          :format => payload[:format],
          :controller => payload[:params]['controller'],
          :action => payload[:params]['action']
        }
      end

      def extract_status(payload)
        if payload[:status]
          payload[:status].to_i
        else
          0
        end
      end

      def runtimes(event)
        { :duration => event.duration,
          :view => event.payload[:view_runtime],
          :db => event.payload[:db_runtime]
        }.inject({}) do |runtimes, (name, runtime)|
          runtimes[name] = runtime.to_f.round(2) if runtime
          runtimes
        end
      end

      def location(event)
        if location = Thread.current[:scrolls_rails_location]
          Thread.current[:scrolls_rails_location] = nil
          { :location => location }
        else
          {}
        end
      end
    end
  end
end
