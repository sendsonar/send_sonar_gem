[![Build Status](https://travis-ci.org/sendsonar/send_sonar_gem.svg)](https://travis-ci.org/sendsonar/send_sonar_gem)

# SendSonar

[Sonar](https://www.sendsonar.com) is an SMS customer engagement platform that allows companies to have 2-way conversations with their customers over SMS - whether it's for sales, customer service, funnel abandonment, or transactional messages.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'send_sonar'
```

And then execute:

    $ bundle

## Compatibility
Works with Ruby 2.0.0 or greater

## Changes
See RELEASE.md

* Ruby 2.0.0 or greater is now required
* Included `publishable_key` in configuration
* Added support for 5 new API endpoints
* `add_customer` has been aliased to `add_update_customer`


## Setup
Initialize the gem by creating an initializer.

* Your production token can be found if you log into https://sendsonar.com, click the left menu and select Settings, then Company Settings
* Your sandbox token can be found if you log into or sign up at https://sandbox.sendsonar.com/, click on the left menu and select Settings, then Company Settings

```ruby
# config/initializers/send_sonar.rb

SendSonar.configure do |config|
  if Rails.env.production?
    config.env = :live
    config.token = ENV['SONAR_PRODUCTION_TOKEN'] || 'YOUR_PRODUCTION_TOKEN'
    config.publishable_key = ENV['SONAR_PRODUCTION_PUBLISHABLE_KEY'] || 'YOUR_PRODUCTION_PUBLISHABLE_KEY'

  elsif Rails.env.staging?
    config.env = :sandbox
    config.token = ENV['SONAR_SANDBOX_TOKEN'] || 'YOUR_SANDBOX_TOKEN'
    config.publishable_key = ENV['SONAR_SANDBOX_PUBLISHABLE_KEY'] || 'YOUR_SANDBOX_PUBLISHABLE_KEY'
  end
end
```

## Usage
The gem offers connections to the following API endpoints:
  * [Send Message](#send-message "Send Message")
  * [Add / Update Customer](#add--update-customer "Add Update Customer")
  * [Send Campaign](#send-campaign "Send Campaign")
  * [Delete Customer Property](#delete-customer-property "Delete Customer Property")
  * [Close Customer](#close-customer "Close Customer")
  * [Get Customer](#get-customer "Get Customer")
  * [Available Phone Number](#available-phone-number "Available Phone Number")

**Note:** Please include a country code for phone numbers (such as +1 for US) in all API calls to us.

### [Send Message](http://docs.sendsonar.com/docs/send-message)
---
[Visit Documentation](http://docs.sendsonar.com/docs/send-message)

```ruby
SendSonar.message_customer(
  text: 'message text',
  to: '+12234567890',
  tag_names: ["attribution"],
  media_url: "http://where_the_pics_live.com/the_bermanator.png"
)
```

The response is a `SendSonar::Message` object with accessors for the parameters listed in the [documentation](http://docs.sendsonar.com/docs/send-message).

Important Notes:
  1. If you send a message to a new phone number the API will automatically create a new user.
  2. We prevent companies from sending the exact same message to customers within 7 seconds to prevent spamming and to preserve the great SMS experience.
  3. In the response, "status" will either be "queued" or "unsubscribed". A "queued" status is a successful response, and means that the message should be sent within seconds. An "unsubscribed" status means that the message will not be sent, as the customer has previously unsubscribed from messages from your business.

### [Add / Update Customer](http://docs.sendsonar.com/docs/addupdate-customer)
---
[Visit Documentation](http://docs.sendsonar.com/docs/addupdate-customer)

```ruby
SendSonar.add_update_customer(
  phone_number: "5555555555",
  email: "user@example.com",
  first_name: "john",
  last_name: "doe",
  picture_url: "http://where_the_pics_live.com/the_bermanator.png",
  properties: { great_customer: "true" }
)
```

Important Notes:
  1. You can send an unlimited number of properties with arbitrary keys and values.
  2. If a customer already exists with the given phone number, that customer will be updated.
  3. The old `add_customer` method continues to work but was aliased to `add_update_customer` for clarity.

The response is a `SendSonar::Customer` object with accessors for the parameters listed in the [documentation](http://docs.sendsonar.com/docs/addupdate-customer).

### [Send Campaign](http://docs.sendsonar.com/docs/send-campaign)
---
[Visit Documentation](http://docs.sendsonar.com/docs/send-campaign)

```ruby
SendSonar.send_campaign(
  to: "+15555555555",
  campaign_id: "XXXXXXXX_XXXX_XXXX"
)
```

The response is a `SendSonar::Response` object with accessors for the parameters listed in the [documentation](http://docs.sendsonar.com/docs/send-campaign).

### [Delete Customer Property](http://docs.sendsonar.com/docs/delete-customer-properties)
---
[Visit Documentation](http://docs.sendsonar.com/docs/delete-customer-properties)

```ruby
SendSonar.delete_customer_property(
  phone_number: "+15555555555",
  property_name: "delete_me"
)
```

The customer's `email` can be used instead of `phone_number`, so the following is also valid:

```ruby
SendSonar.delete_customer_property(
  email: "user@example.com",
  property_name: "delete_me"
)
```

The response is a `SendSonar::Response` object with accessors for the parameters listed in the [documentation](http://docs.sendsonar.com/docs/delete-customer-properties)

### [Close Customer](http://docs.sendsonar.com/docs/close-customer)
---
[Visit Documentation](http://docs.sendsonar.com/docs/close-customer)

```ruby
SendSonar.close_customer(
  phone_number: "+15555555555"
)
```

The response is a `SendSonar::Response` object with accessors for the parameters listed in the [documentation](http://docs.sendsonar.com/docs/close-customer)

### [Get Customer](http://docs.sendsonar.com/docs/get-customer)
---
[Visit Documentation](http://docs.sendsonar.com/docs/get-customer)

```ruby
SendSonar.get_customer(
  phone_number: "+15555555555"
)
```

The response is a `SendSonar::Customer` object with accessors for the parameters listed in the [documentation](http://docs.sendsonar.com/docs/get-customer)

### [Available Phone Number](http://docs.sendsonar.com/docs/available-phone-number)
---
[Visit Documentation](http://docs.sendsonar.com/docs/available-phone-number)

```ruby
SendSonar.available_phone_number
```

The response is a `SendSonar::Response` object with accessors for the parameters listed in the [documentation](http://docs.sendsonar.com/docs/available-phone-number)

## Errors
There are many reasons why requests can fail. There are custom error classes to help you figure out what went wrong.

Note, all request errors inherit from `SendSonar::RequestException`. Therefore you can rescue all request errors with `rescue SendSonar::RequestException`. The current supported error classes are:

  * SendSonar::BadToken
  * SendSonar::TokenOrPublishableKeyNotFound
  * SendSonar::NoActiveSubscription
  * SendSonar::ApiDisabledForCompany
  * SendSonar::RequestTimeout
  * SendSonar::ConnectionRefused
  * SendSonar::UnknownRequestError (the server return an error response that your version of the gem does not recognize.)

## Support
Email api-help@sendsonar.com if you are having issues with the gem or service.

## Contributing

Please file an issue on Github and have a conversation with us before creating a pull request

1. Fork it ( https://github.com/[my-github-username]/send_sonar/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
