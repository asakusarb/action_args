# ActionArgs

Controller action arguments parameterizer for Rails 3 and 4


## What is this?

ActionArgs is a Rails plugin that extends your controller action methods to allow you to specify arguments of interest in the method definition for any action. - in short, Merbish.


## The Controllers

Having the following controller code:

```ruby
class HogeController < ApplicationController
  def fuga(piyo)
    render :text => piyo
  end
end
```

Hitting "/hoge/fuga?piyo=foo" will call `fuga('foo')` and output 'foo'.
This allows you to explicitly state which members of the `params` Hash are used in your controller actions,


## StrongParameters

ActionArgs plays very nice with Rails 4 StrongParameters.

### Required Parameters
Method parameters that you specify are required. If a key of the same name does not exist in the params Hash,
an ArgumentError is raised.

In this `show` action, ActionArgs will require that `id` parameter is provided.
```ruby
class UsersController < ApplicationController
  # the `id` parameter is mandatory
  def show(id)
    @user = User.find id
  end
end
```

### Optional Parameters
Default parameter values are assigned in the standard way. Parameters with a default value will not require a matching item in the `params` Hash.

```ruby
class UsersController < ApplicationController
  # the `page` parameter is optional
  def index(page = nil)
    @users = User.page(page).per(50)
  end
end
```

### StrongParameters - permit

1. Inline declaration

Hashes simply respond to the StrongParameters' `permit` method.

```ruby
class UsersController < ApplicationController
  def create(user)
    @user = User.new(user.permit(:name, :age))
    ...
  end
end
```

2. Declarative white-listing

ActionArgs also provides a declarative `permits` method for controller classes.
Use this to keep your `permit` calls DRY in a comprehensible way.

```ruby
class UsersController < ApplicationController
  # white-lists User model's attributes
  permits :name, :age

  # the given `user` parameter would be automatically permitted by ActionArgs
  def create(user)
    @user = User.new(user)
  end
end
```

By default, action_args deduces the target model name from the controller name.
For example, the `permits` call in `UsersController` expects the model name to be `User`.
If this is not the case, you can specify the :model_name option:

```ruby
class MembersController < ApplicationController
  # white-lists User model's attributes
  permits :name, :age, model_name: 'User'
end
```

## The Scaffold Generator

ActionArgs provides a custom scaffold controller generator that overwrites the default scaffold generator.
Thus, by hitting the scaffold generator command like this:

```sh
% rails g scaffold user name age:integer email
```

The following elegant controller code will be generated:

```ruby
# coding: utf-8

class UsersController < ApplicationController
  permits :name, :age, :email

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show(id)
    @user = User.find(id)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit(id)
    @user = User.find(id)
  end

  # POST /users
  def create(user)
    @user = User.new(user)

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render action: 'new'
    end
  end

  # PUT /users/1
  def update(id, user)
    @user = User.find(id)

    if @user.update_attributes(user)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /users/1
  def destroy(id)
    @user = User.find(id)
    @user.destroy

    redirect_to users_url
  end
end
```

You may notice that
* There are no globalish `params` referrence
* It's quite easy to comprehend what's the actual input value for each action
* You may write the unit test code as if the actions are just normal Ruby methods


## Supported versions

* Ruby 1.9.2, 1.9.3, 2.0.0, 2.1.0 (trunk), JRuby & Rubinius with 1.9 mode

* Rails 3.0.x, 3.1.x, 3.2.x, 4.0 (edge)


## Installation

Put this line in your Gemfile:
```ruby
gem 'action_args'
```

Then bundle:
```sh
% bundle
```

## Notes

### Plain Old Action Methods

Of courese you still can use both Merbish style and plain old Rails style action methods even if this plugin is loaded. `params` parameter is still alive as well. That means, this plugin won't break any existing controller API.

### Argument Naming Convention

Each action method parameter name corresponds to `params` key name. For example, the following beautifully written nested `show` action works perfectly (this might not be a very good example of effective querying, but that's another story).

```ruby
Rails.application.routes.draw do
  resources :authors do
    resources :books
  end
end

class BooksController < ApplicationController
  # GET /authors/:author_id/books/:id
  def show(author_id, id)
    @book = Author.find(author_id).books.find(id)
  end
  ...
end
```

### Default parameter values

You are of course able to specify default values for action parameters such as:

```ruby
class BooksController < ApplicationController
  def index(author_id = nil, page = 1)
    ...
  end
end
```

However, due to some implementation reasons, the `page` variable will be actually defaulted to nil when `page` parameter was not given.

In order to provide default parameter values in perfect Ruby manner, we recommend you to use the Ruby 2.0 "keyword arguments" syntax instead.

```ruby
class BooksController < ApplicationController
  def index(author_id: nil, page: 1)
    ...
  end
end
```

This way, the `page` parameter will be defaulted to 1 as everyone might expect.

## Copyright

Copyright (c) 2011~2013 Asakusa.rb. See MIT-LICENSE for further details.
