require "yaml"

module SimpleDesk
  class Configuration
    ENV_URLS = YAML.load_file(File.expand_path('../endpoints.yml', __FILE__))
    ALLOWED_ENVS = ENV_URLS.keys

    attr_writer :token

    def env
      @env || :sandbox
    end

    def token
      @token || raise(SimpleDesk::ConfigurationError.new('You need to set your token, see SimpleDesk Readme'))
    end

    def env=(env_sym)
      if ALLOWED_ENVS.include?(env_sym.to_s)
        @env = env_sym.to_s
      else
        raise SimpleDesk::ConfigurationError.new("You attempted to set Simpledesk env to #{env_sym}. Should be one of #{env_choices}")
      end
    end

    private

    def env_choices
      (ALLOWED_ENVS - ['local']).join(', ')
    end
  end
end
