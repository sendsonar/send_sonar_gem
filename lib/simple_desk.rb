require "simple_desk/version"
require "net/http"
require "uri"

class Api
	BASE_URL = "https://www.getsimpledesk.com"
	TOKEN = ENV['SIMPLE_DESK_TOKEN'] || "ucMKQtZ0CQkgfGzTj6lOJe2VRvoRHM8z"

	def add_customer(params)
		uri = URI.parse(build_url("add_customer", params))
		response = Net::HTTP.get_response(uri)
	end	
	alias_method :update_customer, :add_customer


	def build_url(type = nil, params=nil)
		url = post_url(type)

		if params
			string = ''
			url << "&"
			params.each { |k,v| string << "#{k}=#{v}&" }

			url << string
			url = url[0...-1] if (url[-1] == '&')
		end
		return url
	end

	def post_url(type)
		if type == nil
			"#{BASE_URL}?token=#{TOKEN}"
		else
			case type
			when "message_customer"
				"#{BASE_URL}/api_send_message?token=#{TOKEN}"
			when "add_customer" || "update_customer"
				"#{BASE_URL}/api_add_customer?token=#{TOKEN}"
			end
		end
	end

	def message_customer(message_and_phone_number)
		url = post_url
		url << "&" 
		string = ''
		message_and_phone_number.each { |k,v| string << "#{k}=#{v}&" }
		url << string
		url = post_url[0...-1] if post_url[-1]
	end

		# https://www.getsimpledesk.com/api_send_message

end
