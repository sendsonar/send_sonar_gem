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
        raise "SONAR ERROR: #{e.response} - #{e.message}"
      end
    end
  end
end
