module WssAgent
  class CLI < Thor
    desc "config", "create config file"
    def config
      File.open(File.join(Dir.pwd, 'wss_agent.yml'), 'w') do |f|
        f << "Test config"
      end
    end

    desc 'list', 'display list dependencies'

    def list
      results = Specifications.list
      ap results
    rescue Bundler::GemfileNotFound => ex
      ap ex.message
    rescue Bundler::GemNotFound => ex
      ap ex.message
      ap "Could you execute 'bundle install' before"
    end

    desc 'sync', 'sync list dependencies with server'
    def sync
      ap Specifications.sync
    end

  end
end
