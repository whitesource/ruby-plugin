module WssAgent
  class CLI < Thor
    desc "config", "create config file"
    def config
      File.open(File.join(Dir.pwd, Configure::CURRENT_CONFIG_FILE), 'w') do |f|
        f << File.read(Configure.default_path)
      end
      ap 'created config file: wss_agent.yml'
    end

    desc 'list', 'display list dependencies'
    method_options all: :boolean
    method_options excludes: :string
    method_option :verbose, :aliases => "-v", :desc => "Be verbose"
    def list
      WssAgent.enable_debug! if options['verbose']
      results = Specifications.list(options)
      ap results
    rescue Bundler::GemfileNotFound => ex
      ap ex.message
    rescue Bundler::GemNotFound => ex
      ap ex.message
      ap "Could you execute 'bundle install' before"
    end

    desc 'update', 'update list dependencies with server'
    method_options all: :boolean
    method_options excludes: :string
    method_option :verbose, :aliases => "-v", :desc => "Be verbose"
    def update
      WssAgent.enable_debug! if options['verbose']
      Specifications.update(options)
    rescue => ex
      ap ex.message
    end
  end
end
