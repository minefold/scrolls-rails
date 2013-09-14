require 'scrolls'
require 'scrolls/rails/rack/quiet_logger'
require 'scrolls/rails/log_subscriber'
require 'scrolls/rails/version'

require 'active_support/log_subscriber'
require 'active_support/notifications'

require 'action_view/log_subscriber'
require 'action_controller/log_subscriber'

module Scrolls
  module Rails
    extend self

    def setup(app)
      detach_existing_subscribers
      Scrolls::Rails::LogSubscriber.attach_to(:action_controller)
    end

    def detach_existing_subscribers
      ActiveSupport::LogSubscriber.log_subscribers.each do |subscriber|
        case subscriber
        when ActionView::LogSubscriber
          unsubscribe(:action_view, subscriber)
        when ActionController::LogSubscriber
          unsubscribe(:action_controller, subscriber)
        end
      end
    end

    def custom_fields=(fields)
      @custom_fields = fields
    end

    def custom_fields
      @custom_fields || []
    end

  # private

    def unsubscribe(component, subscriber)
      events = events_for_subscriber(subscriber)

      events.each do |event|
        notifier = ActiveSupport::Notifications.notifier
        notifier.listeners_for("#{event}.#{component}").each do |listener|
          if listener.instance_variable_get('@delegate') == subscriber
            ActiveSupport::Notifications.unsubscribe(listener)
          end
        end
      end
    end

    def events_for_subscriber(subscriber)
      subscriber.public_methods(false).reject {|method| method.to_s == 'call' }
    end

  end
end
