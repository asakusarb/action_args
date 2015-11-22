require 'test_helper'

class StoresControllerTest < ActionController::TestCase
  test 'GET show' do
    tatsu_zine = Store.create! name: 'Tatsu-zine'
    get :show, :id => tatsu_zine.id

    assert_equal tatsu_zine, assigns(:store)
  end

  test 'POST create' do
    store_count_was = Store.count
    post :create, :store => {name: 'Tatsu-zine', url: 'http://tatsu-zine.com'}

    assert_equal 1, Store.count - store_count_was
  end
end

class Admin::BooksControllerTest < ActionController::TestCase
  # this action doesn't permit price of new book
  test 'POST create' do
    post :create, :book => {title: 'naruhoUnix', price: 30}

    assert_equal 'naruhoUnix', Book.last.title
    assert_nil Book.last.price
  end

  # this action doesn't permit title to update
  test 'PATCH update' do
    book = Book.create! title: 'RHG', price: 10
    patch :update, :id => book.id, :book => {title: 'naruhoUnix', price: 30}

    assert_equal 'RHG', Book.last.title
    assert_equal 30, Book.last.price
  end
end

class Admin::AccountsControllerTest < ActionController::TestCase
  test 'POST create' do
    admin_account_count_was = Admin::Account.count
    post :create, :admin_account => {name: 'amatsuda'}

    assert_equal 1, Admin::Account.count - admin_account_count_was
  end
end
