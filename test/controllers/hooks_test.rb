# frozen_string_literal: true
require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  setup do
    Book.delete_all
    @book = Book.create! title: 'Head First ActionArgs'
    get :show, params: {id: @book.id}
  end

  sub_test_case 'before_action' do
    test 'via Symbol' do
      assert_equal @book, assigns(:book)
    end

    test 'via String' do
      assert assigns(:string_filter_executed)
    end

    test 'via Proc' do
      assert assigns(:proc_filter_executed)
    end
  end

  test 'around_action' do
    assert_not_nil assigns(:elapsed_time)
  end
end
