# SimpleDesk

[Simple Desk](https://www.getsimpledesk.com) is a skin on top of the twillio API which makes it much easier to use. This simple wrapper is a gem to quickly integrate with Simple Desk in seconds.

## Installation

Add this line to your application's Gemfile:

    gem 'simple_desk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_desk

## Usage
Add your API token to your `application_root/.env` file, or create one if you don't have it.
    SIMPLE_DESK_TOKEN=MY_TOKEN

###**Adding Customers**
To get started and add a new customer, run:
		SimpleDesk.add_customer({phone_number: "1231231232"})

While `phone_number` is required, you can pass additional properties in:
		- phone_number (required)
		- email (optional)
		- first_name (optional)
		- last_name (optional)

Like this:
		
		params = {phone_number: "1231231232", email: "elijah@example.com", first_name: "Elijah", last_name: "Murray"}
		SimpleDesk.add_customer(params)


###**Messaging**
To message a user the format is similar
Note: They do not have to be existing in the system to message. You'll automatically create a new user if you message a new phone number

		message_and_phone_number = {to: 5551231234, text: "Howdy partner!"}
		SimpleDesk.message_customer(message_and_phone_number)
		
## To Do List

Features that still need to be implemented

		- Make generator to accept your API key
		- Add ability to pass in properties and convert to base 64
		- Add auto capitalization for names
		- Parse formatting for phone number

## Contributing

1. Fork it ( https://github.com/[my-github-username]/simple_desk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request