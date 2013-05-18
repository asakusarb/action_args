require 'spec_helper'

describe ActionArgs::ParamsHandler do
  # ActionArgs::ParamsHandler.extract_method_arguments_from_params(method_parameters, params)
  describe 'extract_method_arguments_from_params' do
    subject { ActionArgs::ParamsHandler.extract_method_arguments_from_params method(:m).parameters, params }
    let(:params) { {a: '1', b: '2'} }
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
  end
end
