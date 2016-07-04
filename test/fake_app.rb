# coding: utf-8

# config
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

module ActionArgsTestApp
  class Application < Rails::Application
    config.secret_key_base = config.secret_token = [*'A'..'z'].join
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
    resources :accounts
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
module Admin
  def self.table_name_prefix() 'admin_' end
  class Account < ActiveRecord::Base
  end
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
    render plain: @author.name
  end
end
class BooksController < ApplicationController
  before_action :set_book, only: :show
  before_action -> { @proc_filter_executed = true }, only: :show
  before_action '@string_filter_executed = true', only: :show
  around_action :benchmark_action
  before_action :omg
  skip_before_action :omg

  # optional parameter
  def index(page = 1, q = nil, limit = 10)
    @books = Book.limit(limit.to_i).offset(([page.to_i - 1, 0].max) * 10)
    @books = @books.where('title like ?', "%#{q}%") unless q.blank?
    render plain: 'index', books: @books
  end

  def show(id)
    render plain: @book.title
  end

  def create(book)
    book = book.permit :title, :price
    @book = Book.create! book
    render plain: @book.title
  end

  private
    def set_book(id)
      @book = Book.find(id)
    end

    def benchmark_action
      start  = Time.now
      yield
      @elapsed_time = Time.now - start
    end

    def omg
      raise '💣'
    end
end
class StoresController < ApplicationController
  permits :name, :url

  def show(id)
    @store = Store.find(id)
    render plain: @store.name
  end

  def new(store = nil)
    @store = Store.new store
    render plain: @store.name
  end

  def create(store)
    @store = Store.create! store
    render plain: @store.name
  end
end
module Admin
  class AccountsController < ::ApplicationController
    permits :name, model_name: 'Admin::Account'

    def create(admin_account)
      @admin_account = Admin::Account.create! admin_account
      render plain: @admin_account.name
    end
  end

  class BooksController < ::ApplicationController
    permits :title

    def create(book)
      @book = Book.create! book
      render plain: @book.title
    end
  end
end

require_relative 'kwargs_controllers'
require_relative 'kwargs_keyreq_controllers' if RUBY_VERSION >= '2.1'

# migrations
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:authors) {|t| t.string :name}
    create_table(:books) {|t| t.string :title; t.integer :price}
    create_table(:stores) {|t| t.string :name; t.string :url}
    create_table(:admin_accounts) {|t| t.string :name}
  end
end

if ActiveRecord::Base.connection.respond_to? :data_source_exists?
  CreateAllTables.up unless ActiveRecord::Base.connection.data_source_exists? 'authors'
else
  CreateAllTables.up unless ActiveRecord::Base.connection.table_exists? 'authors'
end
