require 'spec_helper'

describe BooksController do
  describe 'GET index (having an optional parameter)' do
    context 'without page parameter' do
      before { get :index }
      its(:response) { should be_success }
    end

    context 'with page parameter' do
      before { get :index, page: 3 }
      its(:response) { should be_success }
    end

    context 'first param is nil and second is not nil' do
      let!(:rhg) { Book.create! title: 'RHG' }
      let!(:awdwr) { Book.create! title: 'AWDwR' }
      before { get :index, q: 'RH' }
      subject { assigns :books }
      it { should == [rhg] }
    end
  end

  describe 'GET show' do
    let(:rhg) { Book.create! title: 'RHG' }
    before { get :show, :id => rhg.id }
    subject { assigns :book }
    it { should == rhg }
  end

  describe 'POST create' do
    let(:rhg) { Book.create! title: 'RHG' }
    it { expect { post :create, :book => {title: 'AWDwR', price: 24} }.to change(Book, :count).by(1) }
  end
end
