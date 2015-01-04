module WssAgent
  class Configure

    DEFAULT_CONFIG_FILE = 'default.yml'
    CURRENT_CONFIG_FILE = 'wss_agent.yml'

    extend SingleForwardable
    def_delegator :current, :[]

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
        Bundler.root.join(CURRENT_CONFIG_FILE).to_s
      end

      def current
        if defined?(Bundler) && File.exist?(current_path)
          default.merge(YAML.load(File.read(current_path)))
        else
          default
        end
      end

      def url
        @url = current['url']
        if @url.nil? || @url == ''
          raise ApiUrlNotFound, "Can't find api url, please make sure you input your whitesource API url in the wss_agent.yml file."
        end
        @url
      end

      def token
        if current['token'].nil? || (current['token'] == '') || (current['token'] == default['token'])
          raise TokenNotFound, "Can't find Token, please make sure you input your whitesource API token in the wss_agent.yml file."
        else
          current['token']
        end
      end
    end
  end
end
