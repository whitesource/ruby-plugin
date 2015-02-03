module WssAgent
  class Configure

    DEFAULT_CONFIG_FILE = 'default.yml'
    CUSTOM_DEFAULT_CONFIG_FILE = 'custom_default.yml'
    CURRENT_CONFIG_FILE = 'wss_agent.yml'
    API_PATH = '/agent'

    extend SingleForwardable
    def_delegator :current, :[]

    class << self

      def default_path
        File.join(File.expand_path('../..', __FILE__), 'config', DEFAULT_CONFIG_FILE)
      end

      def custom_default_path
        File.join(File.expand_path('../..', __FILE__), 'config', CUSTOM_DEFAULT_CONFIG_FILE)
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
        unless File.exist?(current_path)
          return raise NotFoundConfigFile, "Config file isn't exist. Could you please run 'wss_agent config' before."
        end

        @current_config = YAML.load(File.read(current_path))

       unless !!@current_config
          return raise InvalidConfigFile, "Problem reading wss_agent.yml, please check the file is a valid YAML"
        end

        default.merge(@current_config)
      end

      def uri
        @url = current['url']
        if @url.nil? || @url == ''
          raise ApiUrlNotFound, "Can't find the url, please add your Whitesource url destination in the wss_agent.yml file."
        end
        URI(@url)

      rescue URI::Error
        raise ApiUrlInvalid, "Api url is invalid. Could you please check url in wss_agent.yml"
      end

      def port
        uri.port || 80
      end

      def url
        @uri = uri
        [@uri.scheme, @uri.host].join('://')
      end

      def api_path
        @uri = uri
        @url_path = @uri.path
        @url_path == "" ? API_PATH : @url_path
      end

      def token
        if current['token'].nil? || (current['token'] == '') || (current['token'] == default['token'])
          raise TokenNotFound, "Can't find Token, please add your Whitesource API token in the wss_agent.yml file"
        else
          current['token']
        end
      end

      def coordinates
        project_meta = WssAgent::Project.new
        coordinates_config = current['coordinates']
        coordinates_artifact_id = coordinates_config['artifact_id']
        coordinates_version = coordinates_config['version']

        if coordinates_artifact_id.nil? || coordinates_artifact_id == ''
          coordinates_artifact_id = project_meta.project_name
          coordinates_version = project_meta.project_version
        end
        {
          'artifactId' => coordinates_artifact_id,
          'version' => coordinates_version
        }
      end
    end
  end
end
