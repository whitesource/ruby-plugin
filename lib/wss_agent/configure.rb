module WssAgent
  class Configure

    DEFAULT_CONFIG_FILE = 'default.yml'
    CURRENT_CONFIG_FILE = 'wss_agent.yml'

    class << self

      def default_path
        File.join(File.expand_path('../..', __FILE__), 'config', DEFAULT_CONFIG_FILE)
      end

      def exist_default_config?
        File.exist?(default_path)
      end

      def default
        exist_default_config? ? YAML.load(File.read(default_path)) : {}
      end

      def current_path
        Bundler.root.join(CURRENT_CONFIG_FILE)
      end

      def current
        @config ||=
          if defined?(Bundler) && File.exist?(current_path)
            YAML.load(File.read(current_path))
          else
            default
          end
      end

      def url
        @url = current['url']
        if @url.nil? || @url == ''
          ap "Can't find api url, please make sure you input your whitesource API url in the wss_agent.yml file."
          exit 1
        end
        @url
      end

      def token
        #"Can't find Token, please make sure you input your whitesource API token in the wss_agent.yml file."

        if current['token'].nil? || (current['token'] == '') || (current['token'] == default['token'])
          ap "Can't find Token, please make sure you input your whitesource API token in the wss_agent.yml file."
          exit 1
        else
          current['token']
        end
      end
    end
  end
end
