# frozen_string_literal: true

require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  setup do
    Book.delete_all
    @book = Book.create! title: 'Head First ActionArgs'
    get :show, params: {id: @book.id.to_s}
  end

  sub_test_case 'before_action' do
    test 'via Symbol' do
      assert_equal @book, assigns(:book)
      assert_equal @book.id.to_s, assigns(:filter_req_given_id)
      assert_equal @book.id.to_s, assigns(:filter_key_given_id)
      if RUBY_VERSION > '2.1'
        assert_equal @book.id.to_s, assigns(:filter_keyreq_given_id)
      end
    end

    if Rails.version < '5.1'
      test 'via String' do
        assert assigns(:string_filter_executed)
      end
    end

    test 'via Proc' do
      assert assigns(:proc_filter_executed)
    end
  end

  test 'around_action' do
    assert_not_nil assigns(:elapsed_time)
  end
end
