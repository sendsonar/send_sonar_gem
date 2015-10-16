require 'spec_helper'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
end

describe 'SendSonar' do
  describe '.configure' do
    context 'token' do
      it 'has a setter' do
        SendSonar.configure do |config|
          config.token = 'YOUR_PRODUCTION_TOKEN'
        end
      end
    end

    context 'env' do
      it 'has a setter' do
        SendSonar.configure do |config|
          config.env = :live
        end
      end

      it 'raises an error if not an allowed option' do
        expect { SendSonar.configure do |config|
          config.env = :bogus_env
        end }.to raise_error(SendSonar::ConfigurationError)
      end
    end
  end

  shared_examples "a mature, error handling gem" do |context|
    context 'with an invalid token' do
      let(:token) { 'FAKE_TOKEN' }

      it 'raises a BadToken error' do
        VCR.use_cassette("#{cassette_group}_bad_token") do
          expect { response }.to raise_error(SendSonar::BadToken, 'SendSonar::BadToken')
        end
      end
    end

    context 'with an inactive subscription' do
      let(:token) { 'tKux9Vwkt0UuTVJqGUO80MGJHCAeebpe' }

      it 'raises a BadToken error' do
        VCR.use_cassette("#{cassette_group}_no_subscription") do
          expect { response }.to raise_error(SendSonar::NoActiveSubscription, 'SendSonar::NoActiveSubscription')
        end
      end
    end

    context 'with disabled API' do
      let(:token) { 'ts9mOO_O5Dc7TOBaEAQym-00RGEl3Uel' }

      it 'raises a BadToken error' do
        VCR.use_cassette("#{cassette_group}_api_disabled") do
          expect { response }.to raise_error(SendSonar::ApiDisabledForCompany, 'SendSonar::ApiDisabledForCompany')
        end
      end
    end

  end

  describe '.add_customer' do
    before do
      SendSonar.configure do |config|
        config.token = token
        config.env = :local
      end
    end

    let(:cassette_group) { "add_customer" }
    let(:response) { SendSonar.add_customer(params) }
    let(:token) { '3Z9L8xFjeNmXL7Yn-pFJUBoxkVWBbl5o' }
    let(:params) do
      { :phone_number => "5555555557",
        :email => "user@example.com",
        :first_name => "john",
        :last_name => "doe",
        :properties => { :great_customer => "true" } }
    end

    it_behaves_like "a mature, error handling gem"

    context 'with invalid params' do
      let(:params) do
        { :phone_numbah => "5555555558" }
      end

      it 'raises a BadRequest error with hint' do
        VCR.use_cassette("add_customer_bad_params") do
          expect { response }.to raise_error(SendSonar::BadRequest,
            '400 Bad Request: {"error":"phone_number is missing"}')
        end
      end
    end

    context 'with proper params, active subscription' do
      it 'returns a new customer' do
        VCR.use_cassette('add_customer') do
          expect(response).to be_a(SendSonar::Customer)
        end
      end

      it 'includes the expected attributes' do
        VCR.use_cassette('add_customer') do
          customer = response
          expect(customer.phone_number).to eq("5555555557")
          expect(customer.email).to eq("user@example.com")
          expect(customer.first_name).to eq("john")
          expect(customer.last_name).to eq("doe")
          expect(customer.properties).to eq({ "great_customer" => "true" })
        end
      end
    end
  end

  describe '.message_customer' do
    before do
      SendSonar.configure do |config|
        config.token = token
        config.env = :local
      end
    end

    let(:cassette_group) { "message_customer" }
    let(:response) { SendSonar.message_customer(params) }
    let(:token) { '3Z9L8xFjeNmXL7Yn-pFJUBoxkVWBbl5o' }
    let(:params) do
      { :to => "5555555557", :text => "this is the message text" }
    end

    it_behaves_like "a mature, error handling gem"

    context 'with invalid params' do
      let(:params) do
        { :toz => "5555555558" }
      end

      it 'raises a BadRequest error with hint' do
        VCR.use_cassette("message_customer_bad_params") do
          expect { response }.to raise_error(SendSonar::BadRequest,
            '400 Bad Request: {"error":"text is missing, to is missing"}')
        end
      end
    end

    context 'with proper params, active subscription' do
      it 'returns a new customer' do
        VCR.use_cassette('message_customer') do
          expect(response).to be_a(SendSonar::Message)
        end
      end

      it 'includes the expected attributes' do
        VCR.use_cassette('message_customer') do
          message = response
          expect(message.to).to eq("5555555557")
          expect(message.text).to eq("this is the message text")
          expect(message.status).to eq("queued")
        end
      end
    end
  end
end
