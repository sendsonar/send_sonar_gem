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

      it 'raises a BadToken exception' do
        VCR.use_cassette("#{cassette_group}_bad_token") do
          expect { response }.to raise_exception(SendSonar::BadToken, 'SendSonar::BadToken')
        end
      end
    end

    context 'with an inactive subscription' do
      let(:token) { 'tKux9Vwkt0UuTVJqGUO80MGJHCAeebpe' }

      it 'raises a NoActiveSubscription exception' do
        VCR.use_cassette("#{cassette_group}_no_subscription") do
          expect { response }.to raise_exception(SendSonar::NoActiveSubscription, 'SendSonar::NoActiveSubscription')
        end
      end
    end

    context 'with disabled API' do
      let(:token) { 'ts9mOO_O5Dc7TOBaEAQym-00RGEl3Uel' }

      it 'raises an ApiDisabledForCompany error' do
        VCR.use_cassette("#{cassette_group}_api_disabled") do
          expect { response }.to raise_exception(SendSonar::ApiDisabledForCompany, 'SendSonar::ApiDisabledForCompany')
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

      it 'raises a BadRequest exception with hint' do
        VCR.use_cassette("add_customer_bad_params") do
          expect { response }.to raise_exception(SendSonar::BadRequest,
            'SendSonar::BadRequest: 400 Bad Request: {"error":"phone_number is missing"}')
        end
      end
    end

    context 'with an invalid phone number' do
      let(:token) { 'tKux9Vwkt0UuTVJqGUO80MGJHCAeebpe' }

      it 'raises a BadRequest exception with Invalid Phone Number error message' do
        VCR.use_cassette("#{cassette_group}_invalid_phone_number") do
          expect { response }.to raise_exception(SendSonar::BadRequest,
            'SendSonar::BadRequest: 400 Bad Request: {"error":"Invalid Phone Number"}')
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

      it 'raises a BadRequest exception with hint' do
        VCR.use_cassette("message_customer_bad_params") do
          expect { response }.to raise_exception(SendSonar::BadRequest,
            'SendSonar::BadRequest: 400 Bad Request: {"error":"text is missing, to is missing"}')
        end
      end
    end

    context 'with an invalid phone number' do
      let(:token) { 'tKux9Vwkt0UuTVJqGUO80MGJHCAeebpe' }

      it 'raises a BadRequest exception with Invalid Phone Number error message' do
        VCR.use_cassette("#{cassette_group}_invalid_phone_number") do
          expect { response }.to raise_exception(SendSonar::BadRequest,
            'SendSonar::BadRequest: 400 Bad Request: {"error":"Invalid Phone Number"}')
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

  shared_examples "an error receiving gem" do |context|
    context 'with an invalid token' do
      let(:token) { 'FAKE_TOKEN' }

      it 'raises a BadToken exception' do
        VCR.use_cassette("#{cassette_group}_bad_token") do
          expect { response }.to raise_exception(SendSonar::TokenOrPublishableKeyNotFound, 'SendSonar::TokenOrPublishableKeyNotFound')
        end
      end
    end
  end

  describe '.send_campaign' do
    before do
      SendSonar.configure do |config|
        config.token = token
        config.env = :sandbox
      end
    end

    let(:cassette_group) { "send_campaign" }
    let(:response) { SendSonar.send_campaign(params) }
    let(:token) { '99siwE4WRn6bg_B_ktm6h2w6Kez0JYLL' }
    let(:recepient_number) { "+13105551111" }
    let(:params) do
      { :to => recepient_number, :campaign_id => "test_d0Bu23" }
    end

    context 'with proper params, active subscription' do
      it 'returns a campaign sent receipt' do
        VCR.use_cassette('send_campaign') do
          expect(response).to be_a(SendSonar::CampaignSent)
        end
      end

      it 'includes the expected attributes' do
        VCR.use_cassette('send_campaign') do
          campaign_sent = response
          expect(campaign_sent.to).to eq(recepient_number)
          expect(campaign_sent.text).to eq("sent")
          expect(campaign_sent.status).to eq("queued")
        end
      end
    end

    it_behaves_like "an error receiving gem"
  end

  describe '.close_customer' do
    before do
      SendSonar.configure do |config|
        config.token = token
        config.env = :sandbox
      end
    end

    let(:cassette_group) { "close_customer" }
    let(:response) { SendSonar.close_customer(params) }
    let(:token) { '99siwE4WRn6bg_B_ktm6h2w6Kez0JYLL' }
    let(:params) do
      { :phone_number => "+13105551111" }
    end

    context 'with proper param, active subscription' do
      it 'returns a customer closed status' do
        VCR.use_cassette('close_customer') do
          expect(response).to be_a(SendSonar::CustomerClosed)
        end
      end

      it 'includes the expected attributes' do
        VCR.use_cassette('close_customer') do
          customer_closed = response
          expect(customer_closed.success).to eq(true)
        end
      end
    end

    it_behaves_like "an error receiving gem"
  end

  describe '.delete_customer_property' do
    before do
      SendSonar.configure do |config|
        config.token = token
        config.env = :sandbox
      end
    end

    let(:cassette_group) { "delete_customer_property" }
    let(:response) { SendSonar.delete_customer_property(params) }
    let(:token) { '99siwE4WRn6bg_B_ktm6h2w6Kez0JYLL' }
    let(:phone_number) { '+13105551111' }
    let(:email) { 'one@example.com' }

    context 'using phone_number param' do
      let(:property_name) { 'foo' }
      let(:params) do
        { :phone_number => phone_number, :property_name => property_name }
      end
      it 'returns a customer property deleted' do
        VCR.use_cassette('delete_customer_property_with_phone_number') do
          expect(response).to be_a(SendSonar::CustomerPropertyDeleted)
        end
      end

      it 'includes the expected attributes' do
        VCR.use_cassette('delete_customer_property_with_phone_number') do
          customer_property_deleted = response
          expect(customer_property_deleted.phone_number).to eq(phone_number)
          expect(customer_property_deleted.email).to eq(email)
          expect(customer_property_deleted.property_name).to eq(property_name)
          expect(customer_property_deleted.phone_number).to eq(phone_number)
          expect(customer_property_deleted.deleted).to eq(true)
        end
      end

      it_behaves_like "an error receiving gem"
    end

    context 'using email param' do
      let(:property_name) { 'bar' }
      let(:params) do
        { :email => email, :property_name => property_name }
      end
      it 'returns a customer property deleted' do
        VCR.use_cassette('delete_customer_property_with_email') do
          expect(response).to be_a(SendSonar::CustomerPropertyDeleted)
        end
      end

      it 'includes the expected attributes' do
        VCR.use_cassette('delete_customer_property_with_email') do
          customer_property_deleted = response
          expect(customer_property_deleted.phone_number).to eq(phone_number)
          expect(customer_property_deleted.email).to eq(email)
          expect(customer_property_deleted.property_name).to eq(property_name)
          expect(customer_property_deleted.phone_number).to eq(phone_number)
          expect(customer_property_deleted.deleted).to eq(true)
        end
      end
    end
  end

  describe '.get_customer' do
    before do
      SendSonar.configure do |config|
        config.token = token
        config.env = :sandbox
      end
    end

    let(:cassette_group) { "get_customer" }
    let(:response) { SendSonar.get_customer(params) }
    let(:token) { '99siwE4WRn6bg_B_ktm6h2w6Kez0JYLL' }
    let(:phone_number) { '+13105551111' }
    let(:params) do
      { :phone_number => phone_number }
    end

    context 'with proper param, active subscription' do
      it 'returns a customer' do
        VCR.use_cassette('get_customer') do
          expect(response).to be_a(SendSonar::Customer)
        end
      end

      it 'includes the expected attributes' do
        VCR.use_cassette('get_customer') do
          customer = response
          expect(customer.phone_number).to eq(phone_number)
          expect(customer).to respond_to(:first_name)
          expect(customer).to respond_to(:last_name)
          expect(customer).to respond_to(:email)
          expect(customer).to respond_to(:assigned_phone_number)
          expect(customer).to respond_to(:subscribed)
          expect(customer).to respond_to(:unsubscribed_at)
          expect(customer).to respond_to(:properties)
        end
      end
    end

    it_behaves_like "an error receiving gem"
  end

  describe '.available_phone_number' do
    before do
      SendSonar.configure do |config|
        config.publishable_key = publishable_key
        config.env = :sandbox
      end
    end

    let(:response) { SendSonar.available_phone_number }
    let(:publishable_key) { 'f77a884d-4c52-4369-90c2-22a3d5607c24' }

    context 'with proper param, active subscription' do
      it 'returns an available number' do
        VCR.use_cassette('available_phone_number') do
          expect(response).to be_a(SendSonar::AvailableNumber)
        end
      end

      it 'includes the expected attributes' do
        VCR.use_cassette('available_phone_number') do
          available_number = response
          expect(available_number).to respond_to(:available_number)
        end
      end
    end

    context 'with an invalid publishable key' do
      let(:publishable_key) { 'BAD_PUBLISHABLE_KEY' }

      it 'raises a TokenOrPublishableKeyNotFound exception' do
        VCR.use_cassette("available_phone_number_bad_publishable_key") do
          expect { response }.to raise_exception(SendSonar::TokenOrPublishableKeyNotFound, 'SendSonar::TokenOrPublishableKeyNotFound')
        end
      end
    end
  end

end
