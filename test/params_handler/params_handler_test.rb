# frozen_string_literal: true

require 'test_helper'
using ActionArgs::ParamsHandler

class ActionArgs::ParamsHandlerTest < ActiveSupport::TestCase
  sub_test_case 'extract_method_arguments_from_params' do
    setup do
      params = {a: '1', b: '2'}
      @controller = Class.new(ApplicationController).new.tap {|c| c.params = params }
    end

    sub_test_case 'no parameters' do
      test 'no parameters' do
        def @controller.m() end

        assert_equal [[], {}], @controller.extract_method_arguments_from_params(:m)
      end
    end

    sub_test_case 'req' do
      test '1 req' do
        def @controller.m(a) end

        assert_equal [['1'], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test '1 req with args named like strong parameters' do
        def @controller.m(a_params) end

        assert_equal [['1'], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test '2 reqs' do
        def @controller.m(a, b) end

        assert_equal [['1', '2'], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test '2 reqs with args named like strong parameters' do
        def @controller.m(a_params, b_params) end

        assert_equal [['1', '2'], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test 'req without a value' do
        def @controller.m(x) end

        assert_raises(ActionController::BadRequest) { @controller.extract_method_arguments_from_params(:m) }
      end
    end

    sub_test_case 'opt' do
      test '1 opt with value' do
        def @controller.m(a = 'a') end

        assert_equal [['1'], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test '1 opt with value with args named like strong parameters' do
        def @controller.m(a_params = 'a') end

        assert_equal [['1'], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test '1 opt without value' do
        def @controller.m(x = 'x') end

        assert_equal [[], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test 'req, opt with value' do
        def @controller.m(a, b = 'b') end

        assert_equal [['1', '2'], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test 'req, opt without value' do
        def @controller.m(a, x = 'x') end

        assert_equal [['1'], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test 'opt with value, opt with value' do
        def @controller.m(a = 'a', b = 'b') end

        assert_equal [['1', '2'], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test 'opt with value, opt without value' do
        def @controller.m(a = 'a', x = 'x') end

        assert_equal [['1'], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test 'opt without value, opt with value' do
        def @controller.m(x = 'x', a = 'a') end

        assert_equal [[nil, '1'], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test 'opt without value, opt without value' do
        def @controller.m(x = 'x', y = 'y') end

        assert_equal [[], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test 'opt with value, req' do
        def @controller.m(a = 'a', b) end

        assert_equal [['1', '2'], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test 'opt without value, req' do
        def @controller.m(x = 'x', a) end

        assert_equal [['1'], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test 'opt without value, opt with value, req' do
        def @controller.m(x = 'x', b = 'b', a) end

        assert_equal [[nil, '2', '1'], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test 'opt with value, opt without value, req' do
        def @controller.m(b = 'b', x = 'x', a) end

        assert_equal [['2', '1'], {}], @controller.extract_method_arguments_from_params(:m)
      end

      test 'opt with value, req without value' do
        def @controller.m(a = 'a', x) end

        assert_raises(ActionController::BadRequest) { @controller.extract_method_arguments_from_params(:m) }
      end

      test 'opt without value, req without value' do
        def @controller.m(x = 'x', y) end

        assert_raises(ActionController::BadRequest) { @controller.extract_method_arguments_from_params(:m) }
      end

      test 'req without value, opt with value' do
        def @controller.m(x, a = 'a') end

        assert_raises(ActionController::BadRequest) { @controller.extract_method_arguments_from_params(:m) }
      end

      test 'req without value, opt without value' do
        def @controller.m(x, y = 'y') end

        assert_raises(ActionController::BadRequest) { @controller.extract_method_arguments_from_params(:m) }
      end
    end

    sub_test_case 'key' do
      test 'key' do
        def @controller.m(a: nil) end

        assert_equal [[], {a: '1'}], @controller.extract_method_arguments_from_params(:m)
      end

      test 'key with args named like strong parameters' do
        def @controller.m(a_params: nil) end

        assert_equal [[], {a_params: '1'}], @controller.extract_method_arguments_from_params(:m)
      end

      test 'key, key without value' do
        def @controller.m(a: nil, x: 'x') end

        assert_equal [[], {a: '1'}], @controller.extract_method_arguments_from_params(:m)
      end
    end

    if RUBY_VERSION >= '2.1'
      eval <<-KWARGS_KEYREQ_TEST
        sub_test_case 'keyreq' do
          test 'keyreq' do
            def @controller.m(a:) end

            assert_equal [[], {a: '1'}], @controller.extract_method_arguments_from_params(:m)
          end

          test 'keyreq with args named like strong parameters' do
            def @controller.m(a_params:) end

            assert_equal [[], {a_params: '1'}], @controller.extract_method_arguments_from_params(:m)
          end

          test 'keyreq, keyreq without value' do
            def @controller.m(a:, x:) end

            assert_raises(ActionController::BadRequest) { @controller.extract_method_arguments_from_params(:m) }
          end
        end
      KWARGS_KEYREQ_TEST
    end
  end

  sub_test_case 'strengthen_params!' do
    setup do
      @params = ActionController::Parameters.new(x: '1', y: '2', foo: {a: 'a', b: 'b'}, bar: {a: 'a', b: 'b'}, baz: {a: 'a', b: 'b'}, hoge: {a: 'a', b: 'b'}, fuga: {a: 'a', b: 'b'}, foo_foo: {a: 'a', b: 'b'}, hoge_hoge: {a: 'a', b: 'b'}, fuga_fuga: {a: 'a', b: 'b'})
    end

    def execute_strengthen_params!(controller)
      c = controller.new
      c.instance_variable_set :@_params, @params
      c.strengthen_params! :a
    end

    test 'requiring via :req, permitting all scalars' do
      execute_strengthen_params! FooController ||= Class.new(ApplicationController) { permits :a, :b; def a(foo) end }

      assert @params[:foo].permitted?
      assert_not_nil @params[:foo][:a]
      assert_not_nil @params[:foo][:b]
    end

    test 'requiring via :req, permitting all scalars with args named like strong parameters' do
      execute_strengthen_params! FooFooController ||= Class.new(ApplicationController) { permits :a, :b; def a(foo_foo_params) end }

      assert @params[:foo_foo].permitted?
      assert_not_nil @params[:foo_foo][:a]
      assert_not_nil @params[:foo_foo][:b]
    end

    test 'requiring via :req, not permitting all scalars' do
      execute_strengthen_params! BarController ||= Class.new(ApplicationController) { permits :a; def a(bar, x = 'x') end }

      assert @params[:bar].permitted?
      assert_not_nil @params[:bar][:a]
      assert_nil @params[:bar][:b]
    end

    test 'requiring via :req, not permitting any scalars' do
      execute_strengthen_params! BazController ||= Class.new(ApplicationController) { def a(baz, aho = 'omg') end }

      refute @params[:baz].permitted?
    end

    test 'requiring via :opt, permitting all scalars' do
      execute_strengthen_params! HogeController ||= Class.new(ApplicationController) { permits :a, :b; def a(hoge = {}) end }

      assert @params[:hoge].permitted?
      assert_not_nil @params[:hoge][:a]
      assert_not_nil @params[:hoge][:b]
    end

    test 'requiring via :opt, permitting all scalars with args named like strong parameters' do
      execute_strengthen_params! HogeHogeController ||= Class.new(ApplicationController) { permits :a, :b; def a(hoge_hoge_params = {}) end }

      assert @params[:hoge_hoge].permitted?
      assert_not_nil @params[:hoge_hoge][:a]
      assert_not_nil @params[:hoge_hoge][:b]
    end

    test 'requiring via :key, permitting all scalars' do
      execute_strengthen_params! FugaController ||= Class.new(ApplicationController) { permits :a, :b; def a(fuga: {}) end }

      assert @params[:fuga].permitted?
      assert_not_nil @params[:fuga][:a]
      assert_not_nil @params[:fuga][:b]
    end

    test 'requiring via :key, permitting all scalars with args named like strong parameters' do
      execute_strengthen_params! FugaFugaController ||= Class.new(ApplicationController) { permits :a, :b; def a(fuga_fuga_params: {}) end }

      assert @params[:fuga_fuga].permitted?
      assert_not_nil @params[:fuga_fuga][:a]
      assert_not_nil @params[:fuga_fuga][:b]
    end

    test '"model_name" option' do
      execute_strengthen_params! PiyoController ||= Class.new(ApplicationController) { permits :a, :b, model_name: 'Foo'; def a(foo) end }

      assert @params[:foo].permitted?
      assert_not_nil @params[:foo][:a]
      assert_not_nil @params[:foo][:b]
    end

    test '"model_name" option with args named like strong parameters' do
      execute_strengthen_params! PiyoPiyoController = Class.new(ApplicationController) { permits :a, :b, model_name: 'Foo'; def a(foo_params) end }

      assert @params[:foo].permitted?
      assert_not_nil @params[:foo][:a]
      assert_not_nil @params[:foo][:b]
    end
  end
end
