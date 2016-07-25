module WssAgent
  class CLI < Thor
    desc 'config', 'create config file'
    def config
      File.open(File.join(Dir.pwd, Configure::CURRENT_CONFIG_FILE), 'w') do |f|
        f << File.read(Configure.custom_default_path)
      end
      ap 'Created the config file: wss_agent.yml'
    end
    map init: :config

    desc 'list', 'display list dependencies'
    method_option :all, type: :boolean
    method_option :excludes, type: :string
    method_option :verbose, aliases: '-v', desc: 'Be verbose'
    def list
      WssAgent.enable_debug! if options['verbose']
      results = Specifications.list(options)
      ap results
    rescue Bundler::GemfileNotFound => ex
      ap ex.message, color: { string: :red }
    rescue Bundler::GemNotFound => ex
      ap ex.message, color: { string: :red }
      ap "Could you execute 'bundle install' before", color: { string: :red }
    end

    desc 'update', 'update open source inventory'
    method_option :all, type: :boolean
    method_option :excludes, type: :string
    method_option :verbose, aliases: '-v', desc: 'Be verbose'
    method_option :force, type: :boolean, aliases: '-f', desc: 'Force Check All Dependencies'
    def update
      WssAgent.enable_debug! if options['verbose']
      Specifications.update(options)
    rescue => ex
      ap ex.message, color: { string: :red }
    end

    desc 'check_policies', 'checking dependencies that they conforms with company policy.'
    method_option :verbose, aliases: '-v', desc: 'Be verbose'
    method_option :force, type: :boolean, aliases: '-f', desc: 'Force Check All Dependencies'
    def check_policies
      WssAgent.enable_debug! if options['verbose']
      Specifications.check_policies(options)
    end

    desc 'version', 'Agent version'
    def version
      puts WssAgent::VERSION
    end
  end
end
