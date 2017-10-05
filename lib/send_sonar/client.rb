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
      else
        response = e.response && JSON.parse(e.response) || {}
        error = response["error"]
        if exception_class = Exceptions::EXCEPTIONS_MAP[error]
          raise exception_class.new(e)
        else
          raise "SONAR ERROR: #{e.response} - #{e.message}"
        end
      end
    end

    def self.delete(url, payload, headers={}, &block)
      RestClient::Request.execute(:method => :delete, :url => url, :payload => payload, :headers => headers, &block)

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
        if exception_class = Exceptions::EXCEPTIONS_MAP[error]
          raise exception_class.new(e)
        else
          raise "SONAR ERROR: #{e.response} - #{e.message}"
        end
      end
    end

    def self.get(url, headers={}, &block)
      RestClient::Request.execute(:method => :get, :url => url, :headers => headers, &block)

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
        if exception_class = Exceptions::EXCEPTIONS_MAP[error]
          raise exception_class.new(e)
        else
          raise "SONAR ERROR: #{e.response} - #{e.message}"
        end
      end
    end

  end
end
