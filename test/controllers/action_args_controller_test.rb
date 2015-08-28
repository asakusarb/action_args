require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  sub_test_case 'GET index (having an optional parameter)' do
    setup do
      @books = []
      Book.delete_all
      100.times {|i| @books << Book.create!(title: 'book'+i.to_s) }
    end

    test 'without page parameter' do
      get :index
      assert 200, response.code
      assert_equal @books[0..9], assigns(:books)
    end

    test 'with page parameter' do
      get :index, page: 3
      assert 200, response.code
      assert_equal @books[20..29], assigns(:books)
    end

    test 'first param is nil and second is not nil' do
      rhg = Book.create! title: 'RHG'
      Book.create! title: 'AWDwR'
      get :index, q: 'RH'
      assert_equal [rhg], assigns(:books)
    end
  end

  test 'GET show' do
    rhg = Book.create! title: 'RHG'
    get :show, :id => rhg.id
    assert_equal rhg, assigns(:book)
  end

  test 'POST create' do
    Book.create! title: 'RHG'
    books_count_was = Book.count
    post :create, :book => {title: 'AWDwR', price: 24}
    assert_equal 1, Book.count - books_count_was
  end
end
