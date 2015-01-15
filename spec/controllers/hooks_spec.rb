require 'spec_helper'

describe BooksController, 'before_action hooks' do
  before do
    Book.delete_all
    @book = Book.create! title: 'Head First ActionArgs'
    get :show, id: @book.id
  end

  context 'via Symbol' do
    subject { assigns :book }
    it { should == @book }
  end

  context 'via String' do
    subject { assigns :string_filter_executed }
    it { should be_true }
  end

  context 'via Proc' do
    subject { assigns :proc_filter_executed }
    it { should be_true }
  end
end
