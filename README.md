# Peek::Activerecord

This plugin displays the ActiveRecord queries run during a request.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'peek-activerecord'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install peek-activerecord

In `/app/assets/stlyesheets/application.scss`:

```
 = require peek/views/activerecord
 = require peek/views/activerecord/pygments
```

In `/app/assets/javascripts/application.coffee`:

```
#= require peek/views/activerecord
```

This works the same way in `application.js` if you have that instead, just put
the require in a comment.

## Usage

Any page with `peek_enabled?` will have a new `ActiveRecord Queries` link. Click
on it to see your queries:

![](https://github-slack.s3.amazonaws.com/monosnap/Your_Builds_2017-06-27_14-00-43.png)

Controllers have a new method, `peek_activerecord_enabled?`, that you can
overwrite to separate AR enabled-ness from peek enabled-ness if you like.

## Development

There's no good development harness yet, sorry. Contributions are welcome if
you're up to it.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bhuga/peek-activerecord. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Peek::Activerecord project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bhuga/peek-activerecord/blob/master/CODE_OF_CONDUCT.md).
