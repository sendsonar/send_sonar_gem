module SendSonar
  module Client
    def self.post(url, payload, headers={}, &block)
      RestClient::Request.execute(:method => :post, :url => url, :payload => payload, :headers => headers, &block)

    rescue Errno::ECONNREFUSED => e
      raise ConnectionRefused.new(e)

    rescue RestClient::RequestTimeout => e
      raise RequestTimeout.new(e)

    rescue RestClient::Exception => e
      if e.http_code == 400
        raise BadRequest.new(e)
      elsif e.to_s.match(/Server broke connection/)
        raise ServerBrokeConnection.new(e)
      else
        begin
          response = e.response && JSON.parse(e.response) || {}
          error = response["error"]
        rescue JSON::ParserError
          error = e.response
        end
        exception_class = Exceptions::EXCEPTIONS_MAP[error] || UnknownRequestError
        raise exception_class.new(e)
      end
    end
  end
end
