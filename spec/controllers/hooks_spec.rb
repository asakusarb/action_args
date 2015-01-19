require 'spec_helper'

describe BooksController, 'action hooks' do
  before do
    Book.delete_all
    @book = Book.create! title: 'Head First ActionArgs'
    get :show, id: @book.id
  end

  describe 'before_action' do
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

  describe 'around_action' do
    subject { assigns :elapsed_time }
    it { should be }
  end
end
