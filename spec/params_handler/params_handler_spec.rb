require 'spec_helper'

describe ActionArgs::ParamsHandler do
  # ActionArgs::ParamsHandler.extract_method_arguments_from_params(method_parameters, params)
  describe 'extract_method_arguments_from_params' do
    let(:params) { {a: '1', b: '2'} }
    subject { ActionArgs::ParamsHandler.extract_method_arguments_from_params method(:m).parameters, params }
    context 'no parameters' do
      before do
        def m() end
      end
      it { should == [] }
    end

    context '1 req' do
      before do
        def m(a) end
      end
      it { should == ['1'] }
    end

    context '2 reqs' do
      before do
        def m(a, b) end
      end
      it { should == ['1', '2'] }
    end

    context '1 opt with value' do
      before do
        def m(a = 'a') end
      end
      it { should == ['1'] }
    end

    context '1 opt without value' do
      before do
        def m(x = 'x') end
      end
      it { should == [] }
    end

    context 'req, opt with value' do
      before do
        def m(a, b = 'b') end
      end
      it { should == ['1', '2'] }
    end

    context 'req, opt without value' do
      before do
        def m(a, x = 'x') end
      end
      it { should == ['1'] }
    end

    context 'opt with value, opt with value' do
      before do
        def m(a = 'a', b = 'b') end
      end
      it { should == ['1', '2'] }
    end

    context 'opt with value, opt without value' do
      before do
        def m(a = 'a', x = 'x') end
      end
      it { should == ['1'] }
    end

    context 'opt without value, opt with value' do
      before do
        def m(x = 'x', a = 'a') end
      end
      it { should == [nil, '1'] }
    end

    context 'opt without value, opt without value' do
      before do
        def m(x = 'x', y = 'y') end
      end
      it { should == [] }
    end

    context 'opt with value, req' do
      before do
        def m(a = 'a', b) end
      end
      it { should == ['1', '2'] }
    end

    context 'opt without value, req' do
      before do
        def m(x = 'x', a) end
      end
      it { should == ['1'] }
    end

    context 'opt without value, opt with value, req' do
      before do
        def m(x = 'x', b = 'b', a) end
      end
      it { should == [nil, '2', '1'] }
    end

    context 'opt with value, opt without value, req' do
      before do
        def m(b = 'b', x = 'x', a) end
      end
      it { should == ['2', '1'] }
    end

    if RUBY_VERSION >= '2'
      eval <<-KWARGS_TEST
        context 'key' do
          before do
            def m(a: nil) end
          end
          it { should == [a: '1'] }
        end

        context 'key, key without value' do
          before do
            def m(a: nil, x: 'x') end
          end
          it { should == [a: '1'] }
        end
      KWARGS_TEST
    end

    if RUBY_VERSION >= '2.1'
      eval <<-KWARGS_KEYREQ_TEST
        context 'keyreq' do
          before do
            def m(a:) end
          end
          it { should == [a: '1'] }
        end

        if Rails::VERSION::MAJOR >= 4
          context 'keyreq, keyreq without value' do
            before do
              def m(a:, x:) end
            end
            it { expect { subject }.to raise_error ::ActionController::BadRequest }
          end
        end
      KWARGS_KEYREQ_TEST
    end
  end

  if defined? ActionController::StrongParameters
    # strengthen_params!(controller_class, method_parameters, params)
    describe 'strengthen_params!' do
      before { ActionArgs::ParamsHandler.strengthen_params! controller, controller.new.method(:a).parameters, params }
      let(:params) { ActionController::Parameters.new(x: '1', y: '2', foo: {a: 'a', b: 'b'}, bar: {a: 'a', b: 'b'}, baz: {a: 'a', b: 'b'}, hoge: {a: 'a', b: 'b'}, fuga: {a: 'a', b: 'b'}) }

      context 'requiring via :req, permitting all scalars' do
        let(:controller) { FooController ||= Class.new(ApplicationController) { permits :a, :b; def a(foo) end } }
        subject { params[:foo] }
        it { should be_permitted }
        its([:a]) { should be }
        its([:b]) { should be }
      end

      context 'requiring via :req, not permitting all scalars' do
        let(:controller) { BarController ||= Class.new(ApplicationController) { permits :a; def a(bar, x = 'x') end } }
        subject { params[:bar] }
        it { should be_permitted }
        its([:a]) { should be }
        its([:b]) { should_not be }
      end

      context 'requiring via :req, not permitting any scalars' do
        let(:controller) { BazController ||= Class.new(ApplicationController) { def a(baz, aho = 'omg') end } }
        subject { params[:baz] }
        it { should_not be_permitted }
      end

      context 'requiring via :opt, permitting all scalars' do
        let(:controller) { HogeController ||= Class.new(ApplicationController) { permits :a, :b; def a(hoge = {}) end } }
        subject { params[:hoge] }
        it { should be_permitted }
        its([:a]) { should be }
        its([:b]) { should be }
      end

      if RUBY_VERSION >= '2'
        eval <<-KWARGS_TEST
          context 'requiring via :key, permitting all scalars' do
            let(:controller) { FugaController ||= Class.new(ApplicationController) { permits :a, :b; def a(fuga: {}) end } }
            subject { params[:fuga] }
            it { should be_permitted }
            its([:a]) { should be }
            its([:b]) { should be }
          end
        KWARGS_TEST
      end

      describe '"model_name" option' do
        let(:controller) { PiyoController ||= Class.new(ApplicationController) { permits :a, :b, model_name: 'Foo'; def a(foo) end } }
        subject { params[:foo] }
        it { should be_permitted }
        its([:a]) { should be }
        its([:b]) { should be }
      end
    end
  end
end
