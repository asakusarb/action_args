require 'spec_helper'

describe KwBooksController do
  describe 'GET index (having an optional parameter)' do
    context 'without giving any kw parameter (not even giving :required one)' do
      if ActionPack::VERSION::MAJOR >= 4
        it { expect { get :index }.to raise_error ActionController::BadRequest }
      else
        it { expect { get :index }.to raise_error ArgumentError }
      end
    end

    context 'without giving any optional kw parameter' do
      before { get :index, author_name: 'nari' }
      its(:response) { should be_success }
    end

    context 'with kw parameter defaults to non-nil value' do
      before { get :index, author_name: 'nari', page: 3 }
      subject { eval response.body }
      its([:author_name]) { should == 'nari' }
      its([:page]) { should == '3' }
      its([:q]) { should == nil }
    end

    context 'with kw parameter defaults to nil' do
      before { get :index, author_name: 'nari', q: 'Rails' }
      subject { eval response.body }
      its([:author_name]) { should == 'nari' }
      its([:page]) { should == '1' }
      its([:q]) { should == 'Rails' }
    end
  end
end
