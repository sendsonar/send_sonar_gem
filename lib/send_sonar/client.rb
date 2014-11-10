module SendSonar
  module Client
    @@open_timeout = 2
    @@timeout = 4

    def self.post(url, payload, headers={}, &block)
      RestClient::Request.execute(:method => :post, :url => url, :payload => payload, :headers => headers,
        :open_timeout => @@open_timeout, :timeout => @@timeout, &block)

    rescue Errno::ECONNREFUSED => e
      raise ConnectionRefused.new(e)

    rescue RestClient::RequestTimeout => e
      raise RequestTimeout.new(e)

    rescue RestClient::Exception => e
      if e.http_code == 400
        raise BadRequest.new(e)
      else
        response = e.response && JSON.parse(e.response) || {}
        error = response["error"]
        exception = error && Exceptions::EXCEPTIONS_MAP[error].new(e) || Exception::UnknownRequestError.new(e)
        raise exception
      end
    end
  end
end
