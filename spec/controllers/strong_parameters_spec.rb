require 'spec_helper'

if Rails::VERSION::MAJOR >= 4
  describe StoresController do
    describe 'GET show' do
      let(:tatsu_zine) { Store.create! name: 'Tatsu-zine' }
      before { get :show, :id => tatsu_zine.id }
      subject { assigns :store }
      it { should == tatsu_zine }
    end

    describe 'POST create' do
      it { expect { post :create, :store => {name: 'Tatsu-zine', url: 'http://tatsu-zine.com'} }.to change(Store, :count).by(1) }
    end
  end
end
