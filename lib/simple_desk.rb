require "simple_desk/version"
require "net/http"
require "uri"

module SimpleDesk
	BASE_URL = "https://www.getsimpledesk.com"
	
	def self.add_customer(params)
		uri = URI.parse(post_url("add_customer"))
		response = Net::HTTP.post_form(uri, params)
	end	
	# alias_method :update_customer, :add_customer

	def self.message_customer(message_and_phone_number)
		uri = URI.parse(post_url("message_customer"))
		response = Net::HTTP.post_form(uri, message_and_phone_number)
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
			"#{BASE_URL}?token=#{ENV['SIMPLE_DESK_TOKEN']}"
		else
			case post_type
			when "message_customer"
				"#{BASE_URL}/api_send_message?token=#{ENV['SIMPLE_DESK_TOKEN']}"
			when "add_customer" || "update_customer"
				"#{BASE_URL}/api_add_customer?token=#{ENV['SIMPLE_DESK_TOKEN']}"
			end
		end
	end

end
