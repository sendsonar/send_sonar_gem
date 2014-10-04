require "simple_desk/version"
require "simple_desk/configuration"
require "simple_desk/exceptions"
require "simple_desk/client"
require "rest_client"
require "ostruct"
require "json"

module SimpleDesk
  extend self

  def configure
    yield @config ||= Configuration.new
  end

  def add_customer(params)
    resp = Client.post url_for(:customers), params, headers
    Customer.new(JSON.parse(resp))
  end

  def message_customer(params)
    resp = Client.post url_for(:messages), params, headers
    Message.new(JSON.parse(resp))
  end

  private

  attr_reader :config

  def headers
    { :token => config.token, :client => "rubygem #{SimpleDesk::VERSION}" }
  end

  def url_for(key)
    Configuration::ENV_URLS[config.env.to_s][key.to_s]
  end
end

