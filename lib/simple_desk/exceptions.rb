require 'ostruct'

module SimpleDesk
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
      @original_exception.inspect
    end

    def to_s
      inspect
    end
  end

  class BadToken < RequestException; end
  class NoActiveSubscription < RequestException; end
  class ApiDisabledForCompany < RequestException; end
  class UnknownRequestError < RequestException; end
  class RequestTimeout < RequestException; end
  class ConnectionRefused < RequestException; end

  class Customer < OpenStruct; end
  class Message < OpenStruct; end

  module Exceptions
    EXCEPTIONS_MAP = {
      "Bad Token" => BadToken,
      "No Active Subscription" => NoActiveSubscription,
      "Api Disabled For Company" => ApiDisabledForCompany
    }
  end
end
