module WssAgent
  class Configure

    DEFAULT_CONFIG_FILE = 'default.yml'
    CURRENT_CONFIG_FILE = 'wss_agent.yml'

    class << self

      def default_path
        File.join(File.expand_path('../..', __FILE__), 'config', DEFAULT_CONFIG_FILE)
      end

      def default
        if File.exist?(default_path)
          YAML.load(File.read(default_path))
        else
          { }
        end
      end

      def current_path
        Bundler.root.join(CURRENT_CONFIG_FILE)
      end

      def current
        if defined?(Bundler) && File.exist?(current_path)
          YAML.load(File.read(current_path))
        else
          default
        end
      end
    end
  end
end
