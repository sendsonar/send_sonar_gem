# SimpleDesk

[Simple Desk](https://www.getsimpledesk.com) is a skin on top of the twillio API which makes it much easier to use. This simple wrapper is a gem to quickly integrate with Simple Desk in seconds.

## To Do List

		- Make generator to accept your API key
		- Add ability to pass in properties and convert to base 64

## Installation

Add this line to your application's Gemfile:

    gem 'simple_desk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_desk

## Usage

		a = Api.new
		a.add_customer({phone_number: "1231231234"})

## Contributing

1. Fork it ( https://github.com/[my-github-username]/simple_desk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
