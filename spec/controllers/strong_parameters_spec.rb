require 'spec_helper'

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

describe Admin::BooksController do
  context "this controller doesn't permit price of new book" do
    describe 'POST create' do
      before { post :create, :book => {title: 'naruhoUnix', price: 30} }

      it 'should not save price of the book' do
        expect(Book.last.price).to be_nil
      end
    end
  end
end

describe Admin::AccountsController do
  describe 'POST create' do
    it { expect { post :create, :admin_account => {name: 'amatsuda'} }.to change(Admin::Account, :count).by(1) }
  end
end
