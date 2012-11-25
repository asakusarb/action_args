# config
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

module ActionArgsTestApp
  class Application < Rails::Application
    config.secret_token = [*'A'..'z'].join
    config.session_store :cookie_store, :key => '_myapp_session'
    config.active_support.deprecation = :log
    config.eager_load = false
  end
end
ActionArgsTestApp::Application.initialize!

# routes
ActionArgsTestApp::Application.routes.draw do
  resources :authors
  resources :books
  resources :stores
end

# models
class Author < ActiveRecord::Base
end
class Book < ActiveRecord::Base
end
class Store < ActiveRecord::Base
end

# helpers
module ApplicationHelper; end

# controllers
class ApplicationController < ActionController::Base
end
class AuthorsController < ApplicationController
  def show
    @author = Author.find params[:id]
    render text: @author.name
  end
end
class BooksController < ApplicationController
  def show(id)
    @book = Book.find(id)
    render text: @book.title
  end

  def create(book)
    book = book.permit :title, :price if Rails::VERSION::MAJOR >= 4
    @book = Book.create! book
    render text: @book.title
  end
end
if Rails::VERSION::MAJOR >= 4
  class StoresController < ApplicationController
    permits :name, :url

    def show(id)
      @store = Store.find(id)
      render text: @store.name
    end

    def create(store)
      @store = Store.create! store
      render text: @store.name
    end
  end
end

# migrations
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:authors) {|t| t.string :name}
    create_table(:books) {|t| t.string :title; t.integer :price}
    create_table(:stores) {|t| t.string :name; t.string :url}
  end
end
