require 'spec_helper'
require "simple_desk"

describe Api do
	before :each do
    @api = Api.new
    @phone = {phone_number: "555#{Random.rand(10_000_000 - 1_000_000)}"}
    @user = {first_name: "Elijah", last_name: "Murray"}.merge!(@phone)
	end

	describe "#build_url" do
		it "build_url returns a string" do
			@api.build_url.should eql "https://www.getsimpledesk.com?token=ucMKQtZ0CQkgfGzTj6lOJe2VRvoRHM8z"
		end
	end

	describe "#add_customer" do
		it "add customer successfully" do
			# skip("disabled to not call API")
			request = @api.add_customer(@user)
			request.response.code.should eql "200"
		end
	end

	describe "#message_customer" do
		it "message customer successfully" do
			# skip("disabled to not call API")
			message = "Hi customer!"
			to = {to: @phone[:phone_number]}
			params = {text: message}.merge!(to)
			request = @api.message_customer(params)
			request.response.code.should eql "200"
		end
	end


end
