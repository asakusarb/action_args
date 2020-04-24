# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
# load Rails first
require 'rails'
require 'active_record'
require 'action_controller/railtie'
require 'action_args'
require 'fake_app'
require 'test/unit/rails/test_help'
Bundler.require

module ActionController::TestCase::Assigns
  def assigns(key = nil)
    assigns = {}.with_indifferent_access
    @controller.view_assigns.each { |k, v| assigns.regular_writer(k, v) }
    key.nil? ? assigns : assigns[key]
  end
end
ActionController::TestCase.include ActionController::TestCase::Assigns

if Rails.version < '5'
  module ActionControllerTestingMonkey
    def get(path, params: nil, session: nil)
      super path, params, session
    end

    def post(path, params: nil, session: nil)
      super path, params, session
    end
  end

  ActionController::TestCase.send :prepend, ActionControllerTestingMonkey
end
