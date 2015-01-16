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
  resources :kw_books  # 2.0+ only
  resources :kw_keyreq_books  # 2.1+ only
  resources :stores

  namespace :admin do
    resources :books
  end
end

# models
class Author < ActiveRecord::Base
end
class Book < ActiveRecord::Base
end
class Store < ActiveRecord::Base
end

# mailers
require "action_mailer/railtie"
class UserMailer < ActionMailer::Base
  def send_email_without_args
    mail(
      to:      'to@example.com',
      from:    'from@example.com',
      subject: 'Action Args!!!',
      body:    'test'
    )
  end
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
  if Rails::VERSION::MAJOR >= 4
    before_action :set_book, only: :show
    before_action -> { @proc_filter_executed = true }, only: :show
    before_action '@string_filter_executed = true', only: :show
  else
    before_filter :set_book, only: :show
    before_filter -> { @proc_filter_executed = true }, only: :show
    before_filter '@string_filter_executed = true', only: :show
  end

  # optional parameter
  def index(page = 1, q = nil, limit = 10)
    @books = Book.limit(limit.to_i).offset(([page.to_i - 1, 0].max) * 10)
    @books = @books.where('title like ?', "%#{q}%") unless q.blank?
    render text: 'index', books: @books
  end

  def show(id)
    render text: @book.title
  end

  def create(book)
    book = book.permit :title, :price if Rails::VERSION::MAJOR >= 4
    @book = Book.create! book
    render text: @book.title
  end

  private
    def set_book(id)
      @book = Book.find(id)
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
  module Admin
    class BooksController < ::ApplicationController
      permits :title

      def create(book)
        @book = Book.create! book
        render text: @book.title
      end
    end
  end
end

require_relative 'kwargs_controllers' if RUBY_VERSION >= '2'
require_relative 'kwargs_keyreq_controllers' if RUBY_VERSION >= '2.1'

# migrations
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:authors) {|t| t.string :name}
    create_table(:books) {|t| t.string :title; t.integer :price}
    create_table(:stores) {|t| t.string :name; t.string :url}
  end
end
