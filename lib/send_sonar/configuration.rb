require "yaml"

module SendSonar
  class Configuration
    ENV_URLS = YAML.load_file(File.expand_path('../endpoints.yml', __FILE__))
    ALLOWED_ENVS = ENV_URLS.keys

    attr_writer :token, :publishable_key

    def env
      @env || :sandbox
    end

    def token
      @token || raise(SendSonar::ConfigurationError.new('You need to set your token, see SendSonar Readme'))
    end

    def publishable_key
      @publishable_key || raise(SendSonar::ConfigurationError.new('You need to set your publishable key, see SendSonar Readme'))
    end

    def env=(env_sym)
      if ALLOWED_ENVS.include?(env_sym.to_s)
        @env = env_sym.to_s
      else
        raise SendSonar::ConfigurationError.new("You attempted to set SendSonar env to #{env_sym}. Should be one of #{env_choices}")
      end
    end

    private

    def env_choices
      (ALLOWED_ENVS - ['local']).join(', ')
    end
  end
end
