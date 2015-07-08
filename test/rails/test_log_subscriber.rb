require 'minitest/autorun'

require 'active_support/core_ext/object' # provides .present? && constantize
require 'scrolls/rails/log_subscriber'

class FakeEvent
  attr_accessor :payload
end

# mock Scrolls to something useful for this test
module Scrolls
  class << self
    def log_exception info, ex
      @@info = info
      @@ex = ex
    end

    def info
      @@info
    end

    def exception
      @@ex
    end
  end
end

class ScrollsRailsLogSubscriber < Minitest::Test
  def setup
    @sub = Scrolls::Rails::LogSubscriber.new
    @evt = FakeEvent.new
  end

  def test_process_action_with_array
    @evt.payload = {
      exception: ['Exception', 'Test array']
    }

    @sub.process_action(@evt)

    assert_equal({status: 500}, Scrolls.info)
    assert_kind_of(Exception, Scrolls.exception)
    assert_equal('Test array', Scrolls.exception.message)
  end

  def test_process_action_with_exception
    @evt.payload = {
      exception: Exception.new('Test exception')
    }

    @sub.process_action(@evt)

    assert_equal({status: 500}, Scrolls.info)
    assert_kind_of(Exception, Scrolls.exception)
    assert_equal('Test exception', Scrolls.exception.message)
  end
end
