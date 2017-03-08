# frozen_string_literal: true
require 'test_helper'

class StoresControllerTest < ActionController::TestCase
  test 'GET show' do
    tatsu_zine = Store.create! name: 'Tatsu-zine'
    get :show, params: {id: tatsu_zine.id}

    assert_equal tatsu_zine, assigns(:store)
  end

  sub_test_case 'GET new' do
    test 'without store parameter' do
      get :new
      assert 200, response.code
    end
    test 'with store parameter' do
      get :new, params: {store: {name: 'Tatsu-zine'}}
      assert 200, response.code
      assert_equal 'Tatsu-zine', assigns(:store).name
    end
  end

  test 'POST create' do
    store_count_was = Store.count
    post :create, params: {store: {name: 'Tatsu-zine', url: 'http://tatsu-zine.com'}}

    assert_equal 1, Store.count - store_count_was
  end
end

class MoviesControllerTest < ActionController::TestCase
  test 'POST create' do
    movie_count_was = Movie.count
    post :create, params: {movie: {title: 'Dr. No', actors_attributes: [{name: 'Bernard Lee'}]}}

    assert_equal 1, Movie.count - movie_count_was
  end
end

# this controller doesn't permit price of new book do
class Admin::BooksControllerTest < ActionController::TestCase
  test 'POST create' do
    post :create, params: {book: {title: 'naruhoUnix', price: 30}}

    assert_nil Book.last.price
  end
end

class Admin::AccountsControllerTest < ActionController::TestCase
  test 'POST create' do
    admin_account_count_was = Admin::Account.count
    post :create, params: {admin_account: {name: 'amatsuda'}}

    assert_equal 1, Admin::Account.count - admin_account_count_was
  end
end
