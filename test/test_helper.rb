$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
# load Rails first
require 'rails'
require 'active_record'
require 'action_controller/railtie'
require 'action_args'
require 'fake_app'
require 'test/unit/rails/test_help'
