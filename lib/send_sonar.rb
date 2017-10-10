require 'send_sonar/version'
require 'send_sonar/configuration'
require 'send_sonar/exceptions'
require 'send_sonar/client'
require 'rest_client'
require 'ostruct'
require 'json'

module SendSonar
  extend self

  def configure
    yield @config ||= Configuration.new
  end

  def add_customer(params)
    resp = Client.post url_for(:customers), params, headers
    Customer.new(JSON.parse(resp))
  end

  alias_method :add_update_customer, :add_customer

  def message_customer(params)
    resp = Client.post url_for(:messages), params, headers
    Message.new(JSON.parse(resp))
  end

  def send_campaign params
    resp = Client.post url_for(:campaigns), params, headers
    CampaignSent.new(JSON.parse(resp))
  end

  def close_customer params
    resp = Client.post url_for(:close_customer), params, headers
    CustomerClosed.new(JSON.parse(resp))
  end

  def delete_customer_property params
    resp = Client.delete url_for(:delete_customer_property), params, headers
    CustomerPropertyDeleted.new(JSON.parse(resp))
  end

  def get_customer params
    query = params.merge({ :token => config.token })
    # RestClient forms the GET query string from the params field of the header
    # Set the query hash above to the params field of the header hash below
    resp = Client.get url_for(:customers), { params: query }
    Customer.new(JSON.parse(resp))
  end

  def available_phone_number
    keys_in_header = { :publishable_key => true, :token => false }
    resp = Client.get url_for(:available_phone_number), headers(keys_in_header)
    AvailableNumber.new(JSON.parse(resp))
  end

  private

  attr_reader :config

  def headers include_headers={}
    include_headers = include_headers.merge({:token => true}) unless include_headers.key? :token
    headers = { :client => "rubygem #{SendSonar::VERSION}" }
    headers = headers.merge({ :token => config.token }) if include_headers[:token]
    headers = headers.merge({ :x_publishable_key => config.publishable_key }) if include_headers[:publishable_key]
    headers
  end

  def url_for(key)
    Configuration::ENV_URLS[config.env.to_s][key.to_s]
  end
end

