[![Build Status](https://travis-ci.org/getsimpledesk/simple_desk_gem.svg)](https://travis-ci.org/getsimpledesk/simple_desk_gem)

# SimpleDesk

[Simple Desk](https://www.getsimpledesk.com) is an SMS customer engagement platform that allows companies to have 2-way conversations with their customers over SMS - whether it's for sales, customer service, funnel abandonment, or transactional messages.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_desk'
```

And then execute:

    $ bundle

## Compatibility
Works with Ruby 1.9.1 or greater

## Changes
See RELEASE.md

* Configuration is now done through an initializer
* Support for sandbox server
* When creating a customer, properties is no longer a separate param (see readme)


## Setup
Initialize the gem by creating an initializer.

* Your production token can be found at https://www.getsimpledesk.com/api_info.
* Your sandbox token can be found at https://sandbox.getsimpledesk.com/api_info

```ruby
# config/initializers/simple_desk.rb

SimpleDesk.configure do |config|
  if Rails.env.production?
    config.env = :live
    config.token = ENV['SIMPLEDESK_PRODUCTION_TOKEN'] || 'YOUR_PRODUCTION_TOKEN'

  elsif Rails.env.staging?
    config.env = :sandbox
    config.token = ENV['SIMPLEDESK_SANDBOX_TOKEN'] || 'YOUR_PRODUCTION_TOKEN'
  end
end
```



## Usage

The API currently allows sending messages and adding customers.

**Sending Messages**

```ruby
SimpleDesk.message_customer(text: 'message text', to: '1234567890')
```
The response is a `SimpleDesk::Message` object with the following accessors:

  * to (phone number as string)
  * text
  * status

Status is one of "queued" or "unsubscribed". Messages with "queued" status are usually sent within seconds. Messages with "unsubscribed" status will not be sent, as customer has previously unsubscribed from API messages.

If you send a message to a new phone number the API will automatically create a new user.

#<SimpleDesk::Message to="1234567890", text="content!", status="queued">

**Adding Customers**

If a customer already exists with the given phone number, that customer will be updated.

```ruby
SimpleDesk.add_customer(
  phone_number: "5555555555",
  email: "user@example.com",
  first_name: "john",
  last_name: "doe",
  properties: { great_customer: "true" }
)
```
You can send an unlimited number of properties with arbitrary keys and values.

The response is a `SimpleDesk::Customer` object with the following accessors:

  * id
  * phone_number (string)
  * email
  * first_name
  * last_name
  * subscribed (boolean)
  * properties (hash)


## Support
Email api-help@getsimpledesk.com if you are having issues with the gem or service.

## Contributing

Please file an issue on Github and have a conversation with us before creating a pull request

1. Fork it ( https://github.com/[my-github-username]/simple_desk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
