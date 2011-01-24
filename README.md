[![](http://stillmaintained.com/fredwu/action_throttler.png)](http://stillmaintained.com/fredwu/action_throttler)

# Action Throttler

There is also a PHP version (for [Kohana](http://kohanaframework.org/)), see here: <http://github.com/fredwu/kthrottler>

## Introduction

Action Throttler is an easy to use Rails plugin to quickly throttle application actions based on configurable duration and limit.

Brought to you by [Envato](http://envato.com) and [Wuit](http://wuit.com).

## Features

* Easy to use, easy to configure
* Lightweight
* Supports both Rails 2 and 3

## Limitations

* Supports ActiveRecord only
* Uses Rake instead of Rails Generator for file generation (for compatibility purpose)

## Usage

### Download and install the plugin

#### Rails 2

	script/plugin install http://fredwu@github.com/fredwu/action_throttler.git

#### Rails 3

	rails plugin install http://fredwu@github.com/fredwu/action_throttler.git

### Set up the plugin

To generate the migration file and migrate the database:

	rake action_throttler:migrate
	rake db:migrate

Or alternatively:

	rake action_throttler:auto_migrate

### Configure the actions

The configuration file is located at `PATH_TO_YOUR_APP/config/initializers/action_throttler.rb`.

The configuration block looks like this:

	ActionThrottler::Actions.add :mail do |action|
	  action.duration = 1.hour
	  action.limit    = 10
	end

You can add as many configuration blocks as you like, just make sure you label them properly (i.e. like `:mail` in the example).

In the example, we are setting the `:mail` action to perform at most <em>10</em> times within <em>1</em> hour duration.

### Register the actions in your app

Now we will need to register the actions so they are recorded in the database.

To simply run an action, in your app (presumably somewhere in the controller), do this:

	ActionThrottler::Actions.run(:mail)

`ActionThrottler::Actions.run` will return `true` or `false` depending on whether or not the action is being throttled.

`ActionThrottler::Actions.run` has an alias `ActionThrottler::Actions.can_run` and a negative alias `ActionThrottler::Actions.cannot_run`.

Typically, we would want to produce feedback to the user when an action is throttled, you can do so by:

	if ActionThrottler::Actions.cannot_run(:mail)
	  # tell the user that this action is not performed
	end

`ActionThrottler::Actions.run` also takes an optional `reference` parameter:

	ActionThrottler::Actions.run(:mail, @current_user)

The reference parameter is very useful because we can track and throttle the action based on a reference, such as a user. The parameter accepts a `String`, an `Integer` or an `ActiveRecord` object.

Note that `ActionThrottler::Actions.run` and its aliases will perform the action when possible. If you only want to check to see if an action can be performed, you can do this:

	ActionThrottler::Actions.can_be_run?(:mail, @current_user)

`ActionThrottler::Actions.can_be_run?` returns `true` or `false` without performing the action, and it also has a negative alias, `ActionThrottler::Actions.cannot_be_run?`.

## Author

Copyright (c) 2010 Fred Wu (<http://fredwu.me>), released under the MIT license

* Envato - <http://envato.com>
* Wuit - <http://wuit.com>
