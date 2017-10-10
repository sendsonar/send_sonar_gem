require 'ostruct'

module SendSonar
  class Exception < RuntimeError;end
  class ConfigurationError < Exception; end

  class RequestException < Exception
    def initialize(original_exception)
      @original_exception = original_exception
    end

    def inspect
      self.class.name
    end

    def to_s
      inspect
    end
  end

  class BadRequest < RequestException
    def initialize(original_exception)
      @original_exception = original_exception
    end

    def inspect
      "#{self.class.name}: #{@original_exception.to_s}: #{@original_exception.http_body}"
    end

    def to_s
      inspect
    end
  end

  class BadToken < RequestException; end
  class InvalidPhoneNumber < RequestException; end
  class NoActiveSubscription < RequestException; end
  class ApiDisabledForCompany < RequestException; end
  class UnknownRequestError < RequestException; end
  class RequestTimeout < RequestException; end
  class ConnectionRefused < RequestException; end
  class TokenOrPublishableKeyNotFound < RequestException; end

  class Customer < OpenStruct; end
  class Message < OpenStruct; end
  class Response < OpenStruct; end

  module Exceptions
    EXCEPTIONS_MAP = {
      "Bad Token" => BadToken,
      "No Active Subscription" => NoActiveSubscription,
      "Api Disabled For Company" => ApiDisabledForCompany,
      "Request Timed Out" => RequestTimeout,
      "Invalid Phone Number" => InvalidPhoneNumber,
      "Token or publishable_key not found" => TokenOrPublishableKeyNotFound
    }
  end
end
