# frozen_string_literal: true

require 'test_helper'

class AuthorsControllerTest < ActionController::TestCase
  test 'GET show' do
    matz = Author.create! name: 'Matz'
    get :show, params: {id: matz.id}
    assert_equal matz, assigns(:author)
  end
end
