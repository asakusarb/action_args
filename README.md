# ActionArgs

Controller action arguments parameterizer for Rails 3+


## What is this?

ActionArgs is a Rails plugin that extends your controller action methods to look and act like simple general Ruby methods with meaningful parameters, or in short, Merbish.


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
So, you do never need to touch the ugly `params` Hash in order to fetch the request parameters.


## StrongParameters

ActionArgs plays very nice with Rails 4 StrongParameters.

In this `show` action, ActionArgs `require`s the `id` parameter.
Hence, if the `id` value has not been specified in the request parameter, it raises an error in the same way as usual Ruby methods do.

```ruby
class UsersController < ApplicationController
  # the `id` parameter is mandatory
  def show(id)
    @user = User.find id
  end
end
```

If you don't want ActionArgs to check the existence of some action parameters, you can make them optional by defining their default values.
Again, it just acts in the same way as usual Ruby methods do.

```ruby
class UsersController < ApplicationController
  # the `page` parameter is optional
  def index(page = nil)
    @users = User.page(page).per(50)
  end
end
```

Hashes in the action method arguments simply respond to the StrongParameters' `permit` method.

```ruby
class UsersController < ApplicationController
  def create(user)
    @user = User.new(user.permit(:name, :age))
    ...
  end
end
```

Moreover, ActionArgs provides declarative `permits` method for controller classes,
so that you can DRY up your `permit` calls in the most comprehensible way.
The `permits` method assumes the model class from the controller name, and
`permit`s the action arguments containing attributes for that model.

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

* Ruby 1.9.2, 1.9.3, 2.0.0 (trunk), JRuby & Rubinius with 1.9 mode

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


## Copyright

Copyright (c) 2011 Asakusa.rb. See MIT-LICENSE for further details.
