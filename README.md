# Bringhurst

Bringhurst watches you run your methods, infers their types, and formats the
results. It does this by aliasing each method in a user-defined collection of
classes and noting the types of their arguments and results.

**Disclaimer**: This is still just a prototype! Don't use it for anything
serious just yet!

## Installation

Add this line to your application's Gemfile:

```ruby
gem "bringhurst"
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install bringhurst
```

## Usage

Once Bringhurst is installed, you'll need to tell it which classes to observe
and when to display the results. I recommend setting it up in your `spec_helper`
by doing something like:

```ruby
require "bringhurst"

RSpec.configure do |config|
  # ...
  def observer
    Bringhurst::TypeObserver.instance
  end

  config.before(:suite) do
    observer.observe_class(Gitsh::CapturingEnvironment)
    observer.observe_class(Gitsh::Completer)
    observer.observe_class(Gitsh::Environment)
  end

  config.after(:suite) do
    puts Bringhurst::Formatter.new(observer.method_calls)
  end
  # ...
end
```

Next, run the tests:

```
$ rspec
```

And see the results:

```
...........................................
Observed Type Signatures
========================
Gitsh::CapturingEnvironment#captured_output: String
Gitsh::CapturingEnvironment#output_stream: IO
Gitsh::Completer#call: String -> Array
Gitsh::Environment#[]=: String -> String -> String
Gitsh::Environment#[]=: Symbol -> String -> String
Gitsh::Environment#config_variables: Hash
Gitsh::Environment#error_stream: StringIO
Gitsh::Environment#fetch: String -> NilClass
Gitsh::Environment#fetch: String -> String
Gitsh::Environment#fetch: String -> TrueClass -> String
Gitsh::Environment#fetch: Symbol -> String
Gitsh::Environment#git_aliases: Array
Gitsh::Environment#git_command: FalseClass -> String
Gitsh::Environment#git_command: String
Gitsh::Environment#git_command: TrueClass -> String
Gitsh::Environment#git_command=: String -> String
Gitsh::Environment#git_commands: RSpec::Mocks::Double
Gitsh::Environment#input_stream: IO
Gitsh::Environment#input_stream: RSpec::Mocks::Double
Gitsh::Environment#output_stream: IO
Gitsh::Environment#output_stream: RSpec::Mocks::Double
Gitsh::Environment#output_stream: StringIO
Gitsh::Environment#print: String -> NilClass
Gitsh::Environment#puts: String -> NilClass
Gitsh::Environment#puts_error: String -> NilClass
Gitsh::Environment#readline_version: String
Gitsh::Environment#repo_config_color: String -> String -> RSpec::Mocks::Double
Gitsh::Environment#repo_current_head: RSpec::Mocks::Double
Gitsh::Environment#repo_has_modified_files?: RSpec::Mocks::Double
Gitsh::Environment#repo_has_untracked_files?: RSpec::Mocks::Double
Gitsh::Environment#repo_heads: RSpec::Mocks::Double
Gitsh::Environment#repo_initialized?: RSpec::Mocks::Double
Gitsh::Environment#tty?: FalseClass
Gitsh::Environment#tty?: TrueClass
```

(I'm hijacking the lovely [gitsh](https://github.com/thoughtbot/gitsh) here for
my examples.)

You can use it in places other than tests, but I wouldn't recommend it -- it'll
definitely adversely affect performance.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/hrs/bringhurst.

## Weird name.

"Bringhurst" references one of my favorite
[observers of types](https://en.wikipedia.org/wiki/The_Elements_of_Typographic_Style).
