require "yaml"

module SendSonar
  class Configuration
    ENV_URLS = YAML.load_file(File.expand_path('../endpoints.yml', __FILE__))
    ALLOWED_ENVS = ENV_URLS.keys

    attr_writer :token

    def env
      @env || :sandbox
    end

    def token
      @token || raise(SendSonar::ConfigurationError.new('You need to set your token, see SendSonar Readme'))
    end

    def env=(env_sym)
      if ALLOWED_ENVS.include?(env_sym.to_s)
        @env = env_sym.to_s
      else
        raise SendSonar::ConfigurationError.new("You attempted to set SendSonar env to #{env_sym}. Should be one of #{env_choices}")
      end
    end

    def open_timeout
      Client.open_timeout
    end

    def open_timeout=(timeout)
      Client.open_timeout = timeout
    end

    def timeout
      Client.timeout
    end

    def timeout=(timeout)
      Client.timeout = timeout
    end

    private

    def env_choices
      (ALLOWED_ENVS - ['local']).join(', ')
    end
  end
end
