# Changelog

## 2.8.0

### Behavior changes

* `permits` is now inherited by subclasses, and a subclass can override it by calling `permits` again. Params of a subclass of a controller that declares `permits` are now filtered by the inherited allow-list
* A `*rest` parameter now receives the elements of an Array param (e.g. `ids[]=1&ids[]=2` for `def index(*ids)`), a one-element Array for a scalar param, and nothing when the param is missing. It used to receive nothing at all
* A missing required parameter that is defined before an optional parameter with a value now raises `ActionController::BadRequest`, instead of being silently passed as `nil`

### Bug fixes

* A positional Hash argument given to a mailer method is no longer dropped (when empty) or turned into keyword arguments
* Keyword arguments given to a mailer method are kept as keyword arguments on Rails < 7 with Ruby 3.2+
* `before_action` / `around_action` callbacks on `ActionController::API` controllers now receive their parameters from `params`
* Anonymous controller classes no longer crash with `NoMethodError`
* `permits` no longer breaks a parameterized mailer's (`.with(...)`) params

### Scaffold generator

* Generated controllers respond with `:unprocessable_content` on Rack 3.1+ (and `:unprocessable_entity` on older Racks)
* Dropped the `update_attributes` fallback, as all supported Rails versions have `update`

### Gem

* Declared runtime dependencies on actionpack and railties (>= 4.1)
* Declared `required_ruby_version` (>= 2.0.0)

## 2.7.3 and earlier

See the [git history](https://github.com/asakusarb/action_args/commits/master).
