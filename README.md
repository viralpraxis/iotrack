# Purst

Purist is a tool designed to help detecting impure ruby code in runtime.

Ruby's stdlib and corelibs include a bunch of impure methods, including

1. randomization: `Kernel.rand`, `Random.rand`, `SecureRandom.hex` and so on

2. IO-related methods like `Kernel.readline` or `IO.popen`

3. specialized side-effects like `Kernel.fork` or `Kernel.syscall`

Purist hooks into ruby's `tracepoint` API to detect any invocation of these methods.
You can see the full list of target methods in `configuration.rb` source file.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add purist

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install purist

## Usage

To check if your code is pure, simply pass it into `Purist.trace` method:

```ruby
Purist.trace { 3 * 3 } # 9
```

If provided block is impure, an exception will be raised:

```ruby
irb(main):001> Purist.trace { p "I'm impure" }
gems/purist/lib/purist/handler.rb:23:in `call': {:path=>"(irb)", :lineno=>1, :module_name=>Kernel, :method_name=>:p} (Purist::Errors::PurityViolationError)
```

You can retrieve exception details like this:

```ruby
exception = Purist.trace { p 1 } rescue $!

p exception.trace_point

{
  :path => ".../zeitwerk-2.6.13/lib/zeitwerk/kernel.rb",
  :lineno => 23,
  :module_name => Kernel,
  :method_name => :require,
  :backtrace => [...]
}
```

### RSpec integration

Purist comes with built-in `RSpec` integration. To enable it, add `require "purist/integrations/rspec"` to your
`spec_helper.rb` and manually include `Purist::Integrations::RSpec::Matchers`:

```ruby
require "purist/integrations/rspec"

...

RSpec.configure do |config|
  ...
  config.include Purist::Integrations::RSpec::Matchers
  ...
end
```

And not `be_pure` and `be_impure` matchers are available:

```ruby
expect { Module.new }.to be_pure
expect { User.where(name: :john) }.to be_impure
```

### Caveats

1. Passing `Purist.trace` check does not mean your function is totally pure, for instance

```ruby
def foo(n)
  if n > 0 # pure branch
    n.succ
  else # impure branch
    p n
  end
end

Purist.trace { foo(3) } # 4
```

2. Ruby stdlib/corelib is quite big, I'm pretty sure some impure functions are missing from the list.

3. Obviously, Purist is unable to detect anything within 3rd-party C extensions.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/viralpraxis/purist. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/viralpraxis/purist/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Purist project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/viralpraxis/purist/blob/main/CODE_OF_CONDUCT.md).
