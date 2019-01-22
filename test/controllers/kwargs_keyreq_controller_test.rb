# frozen_string_literal: true

require 'test_helper'

class KwKeyreqBooksControllerTest < ActionController::TestCase
  sub_test_case 'GET index (having an optional parameter)' do
    test 'without giving any kw parameter (not even giving :required one)' do
      assert_raises(ActionController::BadRequest) { get :index }
    end

    test 'without giving any kw parameter' do
      get :index, params: {author_name: 'nari'}
      assert 200, response.code
    end

    test 'with kw parameter defaults to non-nil value' do
      get :index, params: {author_name: 'nari', page: 3}
      body = eval response.body
      assert_equal 'nari', body[:author_name]
      assert_equal '3', body[:page]
      assert_nil body[:q]
    end

    test 'with kw parameter defaults to nil' do
      get :index, params: {author_name: 'nari', q: 'Rails'}
      body = eval response.body
      assert_equal 'nari', body[:author_name]
      assert_equal '1', body[:page]
      assert_equal 'Rails', body[:q]
    end
  end
end if RUBY_VERSION >= '2.1'
