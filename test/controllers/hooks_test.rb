# frozen_string_literal: true

require 'test_helper'

class ControllerHooksTest < ActionController::TestCase
  self.controller_class = BooksController

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

class OtherHooksTest < ActionController::TestCase
  self.controller_class = AuthorsController

  setup do
    Author.delete_all
    @author = Author.create! name: 'm_put'
    post :create, params: {id: @author.id.to_s, author: {name: 'shyou_hei'}}
  end

  test 'model callbacks are working' do
    assert_equal 'shyou_hei', assigns(:author).name
    assert_equal true, assigns(:author).instance_variable_get(:@model_callback_called)
  end
end
