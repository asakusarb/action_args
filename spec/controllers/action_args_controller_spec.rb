require 'spec_helper'

describe BooksController do
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
