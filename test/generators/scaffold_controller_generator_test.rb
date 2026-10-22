# frozen_string_literal: true

require 'test_helper'
require 'tmpdir'
require 'rails/generators/test_case'
require 'generators/rails/action_args_scaffold_controller_generator'

class ActionArgsScaffoldControllerGeneratorTest < Rails::Generators::TestCase
  tests Rails::Generators::ActionArgsScaffoldControllerGenerator
  destination Dir.mktmpdir
  setup :prepare_destination

  UNPROCESSABLE_STATUS = Rack::Utils::SYMBOL_TO_STATUS_CODE.key?(:unprocessable_content) ? ':unprocessable_content' : ':unprocessable_entity'

  test 'controller' do
    run_generator %w(user name:string age:integer)

    assert_file 'app/controllers/users_controller.rb' do |content|
      assert_match(/permits :name, :age/, content)
      assert_match(/def update\(id, user\)\n.*\n\n    if @user\.update\(user\)/, content)
      assert_match(/render :new, status: #{UNPROCESSABLE_STATUS}$/, content)
      assert_match(/render :edit, status: #{UNPROCESSABLE_STATUS}$/, content)
      assert_no_match(/update_attributes/, content)
    end
  end

  # the --api option was introduced in Rails 5
  if Rails::VERSION::MAJOR >= 5
    test 'API controller' do
      run_generator %w(user name:string age:integer --api)

      assert_file 'app/controllers/users_controller.rb' do |content|
        assert_match(/permits :name, :age/, content)
        assert_match(/def update\(id, user\)\n.*\n\n    if @user\.update\(user\)/, content)
        assert_equal 2, content.scan(/render json: @user\.errors, status: #{UNPROCESSABLE_STATUS}$/).size
        assert_no_match(/update_attributes/, content)
      end
    end
  end
end
