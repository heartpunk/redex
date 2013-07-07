# Redex

This is a lightweight framework for building programming language implementations. It is *not* intended to provide any significant level of performance. Rather, it is intended to both provide significant improvements for interactive debugging capabilities, and for automated code analysis. It's still highly experimental, but I'm ready to accept contributions, if somehow you found this and are interested in helping.

## Installation

Add this line to your application's Gemfile:

    gem 'redex'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redex

## Usage

I'm pretty much doing this sort of thing for testing right now, because there's no parsing component to this repo yet.
```ruby
require 'redex'
Redex::SexpArithmeticInterpreter.new([:+, 1, 2, [:+, 3, 4]]).run
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
