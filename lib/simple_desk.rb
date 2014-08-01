require "simple_desk/version"
require "net/http"
require "uri"

module SimpleDesk
	BASE_URL = "https://www.getsimpledesk.com"

	def self.add_customer(params, customer_properties)
    unless customer_properties.blank?
      props = Base64.urlsafe_encode64(customer_properties.to_json)
      params.merge(properties: props)
    end
  	url = URI.parse(post_url("add_customer"))
  	req = Net::HTTP::Post.new(url.request_uri)
  	req.set_form_data(params)
  	http = Net::HTTP.new(url.host, url.port)
  	http.use_ssl = true
  	response = http.request(req)
	end
	# alias_method :update_customer, :add_customer

	def self.message_customer(message_and_phone_number)
  	url = URI.parse(post_url("message_customer"))
  	req = Net::HTTP::Post.new(url.request_uri)
  	req.set_form_data(message_and_phone_number)
  	http = Net::HTTP.new(url.host, url.port)
  	http.use_ssl = true
  	response = http.request(req)
	end

	private
	def self.build_url(post_type = nil, params=nil)
		url = post_url(post_type)

		if params
			string = ''
			url << "&"
			params.each { |k,v| string << "#{k}=#{v}&" }

			url << string
			url = url[0...-1] if (url[-1] == '&')
		end

		return url
	end

	def self.post_url(post_type)
		if post_type == nil
			"#{BASE_URL}?token=#{ENV['SIMPLE_DESK_TOKEN'] || CONFIG['simple_desk_token']}"
		else
			case post_type
			when "message_customer"
				"#{BASE_URL}/api_send_message?token=#{ENV['SIMPLE_DESK_TOKEN'] || CONFIG['simple_desk_token']}"
			when "add_customer" || "update_customer"
				"#{BASE_URL}/api_add_customer?token=#{ENV['SIMPLE_DESK_TOKEN'] || CONFIG['simple_desk_token']}"
			end
		end
	end

end
