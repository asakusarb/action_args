# action_args
[![Build Status](https://github.com/asakusarb/action_args/actions/workflows/main.yml/badge.svg)](https://github.com/asakusarb/action_args/actions)

Controller action arguments parameterizer for Rails


## What Is This?

action_args is a Rails plugin that extends your controller action methods to allow you to specify arguments of interest in the method definition for any action. - in short, this makes your Rails controller Merb-ish.


## The Controllers

Having the following controller code:

```ruby
class UsersController < ApplicationController
  def show(id)
    @user = User.find id
  end
end
```

When a request visits "/users/777", it calls `UsersController#show` passing 777 as the method parameter.
This allows you to explicitly state the most important API for the action -- which members of the `params` Hash are used in your controller actions -- in a perfectly natural Ruby way!


## Method Parameter Types in Ruby, and How action_args Handles Parameters

### Required Parameters (:req)
Method parameters that you specify are required. If a key of the same name does not exist in the params Hash, ActionContrller::BadRequest is raised.

In this `show` action, action_args will require that `id` parameter is provided.

```ruby
class UsersController < ApplicationController
  # the `id` parameter is mandatory
  def show(id)
    @user = User.find id
  end
end
```

### Optional Parameters (:opt)
Default parameter values are assigned in the standard way. Parameters with a default value will not require a matching item in the `params` Hash.

```ruby
class UsersController < ApplicationController
  # the `page` parameter is optional
  def index(page = nil)
    @users = User.page(page).per(50)
  end
end
```

### Keyword Argument (:key)
If you think this Ruby 2.0 syntax reads better, you can choose this style for defining your action methods.
This just works in the same way as `:opt` here.

```ruby
class UsersController < ApplicationController
  # the `page` parameter is optional
  def index(page: nil)
    @users = User.page(page).per(50)
  end
end
```

### Required Keyword Argument (:keyreq)
`:keyreq` is the required version of `:key`, which was introduced in Ruby 2.1.
You can use this syntax instead of `:req`.

```ruby
class CommentsController < ApplicationController
  def create(post_id:, comment:)
    post = Post.find post_id
    if post.create comment
      ...
  end
end
```

## StrongParameters - permit

action_args plays very nice with Rails 4 StrongParameters.

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

2. Declarative allow-listing

action_args also provides a declarative `permits` method for controller classes.
Use this to keep your `permit` calls DRY in a comprehensible way.

```ruby
class UsersController < ApplicationController
  # allow-lists User model's attributes
  permits :name, :age

  # the given `user` parameter would be automatically permitted by action_args
  def create(user)
    @user = User.new(user)
  end
end
```

By default, action_args deduces the target model name from the controller name.
For example, the `permits` call in `UsersController` expects the model name to be `User`.
If this is not the case, you can specify the `:model_name` option:

```ruby
class MembersController < ApplicationController
  # allow-lists User model's attributes
  permits :name, :age, model_name: 'User'
end
```


## Filters

action_args works in filters, in the same way as it works in controller actions.

```ruby
class UsersController < ApplicationController
  before_action :set_user, only: :show

  def show
  end

  # `params[:id]` will be dynamically assigned to the method parameter `id` here
  private def set_user(id)
    @user = User.find(id)
  end
end
```


## The *_params Convention

For those who are familiar with the Rails scaffold's default naming style, you can add `_params` suffix to any of the parameter names in the method signatures.
It just matches with the params name without `_params`.

For instance, these two actions both pass `params[:user]` as the method parameter.

```ruby
# without _params
def create(user)
  @user = User.new(user)
  ...
end
```

```ruby
# with _params
def create(user_params)
  @user = User.new(user_params)
  ...
end
```

This naming convention makes your controller code look much more compatible with the Rails' default scaffolded code,
and so it may be actually super easy for you to manually migrate from the legacy scaffold controller to the action_args style.


## The Scaffold Generator

action_args provides a custom scaffold controller generator that overwrites the default scaffold generator.
Thus, by hitting the scaffold generator command like this:

```sh
% rails g scaffold user name age:integer email
```

The following elegant controller code will be generated:

```ruby
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
      render :new
    end
  end

  # PUT /users/1
  def update(id, user)
    @user = User.find(id)

    if @user.update(user)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy(id)
    @user = User.find(id)
    @user.destroy

    redirect_to users_url, notice: 'User was successfully destroyed.'
  end
end
```

You may notice that
* There are no global-ish `params` reference
* It's quite easy to comprehend what's the actual input value for each action
* You may be able to write the unit test code without mocking `params` as if the actions are just normal Ruby methods


## Supported Versions

* Ruby 2.0.0, 2.1.x, 2.2.x, 2.3.x, 2.4.x, 2.5.x, 2.6.x, 2.7.x, 3.0.x, 3.1 (trunk), JRuby, & Rubinius with 2.0+ mode

* Rails 4.1.x, 4.2.x, 5.0, 5.1, 5.2, 6.0, 6.1, 7.0, 7.1 (edge)

For Rails 4.0.x, please use Version 1.5.4.


## Installation

Bundle the gem to your Rails app by putting this line in your Gemfile:

```ruby
gem 'action_args'
```

## Notes

### Plain Old Action Methods

Of course you still can use both Merb-like style and plain old Rails style action methods even if this plugin is loaded. `params` parameter is still alive as well. That means, this plugin won't break any existing controller API.

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

### Default Parameter Values

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

Copyright (c) 2011- Asakusa.rb. See MIT-LICENSE for further details.
